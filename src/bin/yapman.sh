#!/usr/bin/env bash
source ../share/yapman/_globals.sh
source ../share/yapman/_help.sh
source ../share/yapman/_deps.sh
source ../share/yapman/_init.sh
source ../share/yapman/_out.sh
source ../share/yapman/_main.sh

version() {
	"$echo" -e $VERSION
}

clone_repo() {
	if [ "$#" -eq 1 ]
	then
		"$git" clone -q "${AUR_DOMAIN}/${1}.git" && return 0 || return 1
	fi
}

install() {
	local clean
	local remove
	local syncdeps
	if [ "${clean_after_build}" = "false" ]
	then
		clean=""
	else
		clean="c" 
	fi
	if [ "${remove_deps_after_build}" = "false" ]
	then
		remove=""
	else
		remove="r"
	fi
	if [ "${sync_missing_deps_pacman}" = "false" ]
	then
		syncdeps=""
	else
		syncdeps="s"
	fi
	"$makepkg" -${syncdeps}i${remove}${clean}
}

update() {
	cd "${YapmanPackagePath}" || exit 1
	for folder in *
	do
		cd "$YapmanPackagePath/$folder" || exit 1
		print_ok "Checking updates 4 ${BOLDB}${folder}${NORMAL}"
		if [ "$("$git" pull | grep "Already up to date.")" = "Already up to date." ]
		then
			print_ok "Already up to date."
		else
			print_ok "${BOLDB}${folder}${NORMAL} needs update."
			if confirm "Update now?"
			then
				install
			else
				print_warning "Update it ASAP."
			fi
		fi
	done
}

install_package() {
	if [ $# -ge 1 ]
	then
		for package in "$@"
		do
			print_ok "Getting ready to install ${BOLDB}${package}${NORMAL}"
			local cache_path="${YapmanCachePath}/install_${package}.json"
			curl -s -o "$cache_path" "${AUR_INFO_URL}${package}"
			local status=$("$jq" -r '.type' "$cache_path")
			if [ "$status" = "error" ]
			then
				print_err "$("$jq" -r '.error' "$cache_path")"
			elif [ "$status" = "multiinfo" ] && [ -d "$YapmanPackagePath" ]
			then
				cd "$YapmanPackagePath" || print_err "We couldn't find: ${YapmanPackagePath}"
				local package_base="$("$jq" -r '.results[0].PackageBase' "$cache_path")"
				if clone_repo "$package_base"
				then
					cd "$package_base" || exit 1
					install
				else
					print_err "Something we did not calculated happened.  :/"
					exit 1
				fi

			else
				print_err "We've encountered some unexpected results."
				exit 1
			fi
		done
	else
		arg_err
	fi
}

get_package() {
	if [ $# -ge 1 ]
	then
		for package in "$@"
		do
			print_ok "Grabbing ${BOLDB}${package}${NORMAL}..."
			local cache_path
			cache_path="${YapmanCachePath}/get_${package}.json"
			curl -s -o "$cache_path" "${AUR_INFO_URL}${package}"
			local status
			status="$("$jq" -r '.type' "$cache_path")"
			if [ "$status" = "error" ]
			then
				print_err "$("$jq" -r '.error' "$cache_path")"
			elif [ "$status" = "multiinfo" ]
			then
				cd "$YapmanPackagePath" || print_err "We couldn't find: ${YapmanPackagePath}" && exit 1
				local package_base="$("$jq" -r '.results[0].PackageBase' "$cache_path")"
				clone_repo "$package_base" && print_ok "Done!.."
			else
				print_err "We've encountered some unexpected results."
				exit 1
			fi
		done
	else
		arg_err
	fi
}

get_package_info() {
	if [ $# -ge 1 ]
	then
		for package in "$@"
		do
			print_ok "Getting info 4 ${BOLDB}${package}${NORMAL}"
			local cache_path
			cache_path="${YapmanCachePath}/info_${package}.json"
			curl -s -o "$cache_path" "${AUR_INFO_URL}${package}"
			local status
			status="$("$jq" -r '.type' "$cache_path")"
			if [ "$status" = "error" ]
			then
				print_err "$("$jq" -r '.error' "$cache_path")"
			elif [ "$status" = "multiinfo" ]
			then
				"$echo" -e "$("$jq" -r '.results[] | to_entries[] | "\u001b[1m\(.key):\u001b[0m \(.value)"' "$cache_path")"
			else
				print_err "We've encountered some unexpected results."
				exit 1
			fi
		done
	else
		arg_err
	fi
}

remove_package() {
	if [ $# -ge 1 ]
	then
		for package in "$@"
		do
			print_warning "Removing ${BOLDB}${package}${NORMAL}"
			if confirm "Are you sure?"
			then
				local recursive
				if confirm "Remove unnecessary dependencies, too?"
				then
					if confirm "Remove explicit dependencies, too?"
					then
						recursive="ss"
					else
						recursive="s"
					fi
				else
					recursive=""
				fi
				local nofile
				if confirm "Remove packages depends on $package?"
				then
					nofile="c"
				else
					nofile=""
				fi
				"$sudo" "$pacman" "-R${recursive}${nofile}"
			else
				print_err "Abort."
			fi
		done
	else
		arg_err
	fi
}

search_package() {
	if [ $# -ge 1 ]
	then
		for package in "$@"
		do
			print_ok "Searhing ${BOLDB}${package}${NORMAL}"
			local cache_path
			cache_path="${YapmanCachePath}/search_results_${package}.json"
			curl -s -o "$cache_path" "${AUR_SEARCH_URL}${package}"
			local status
			status=$("$jq" -r '.type' "$cache_path")
			if [ "$status" = "error" ]
			then
				print_err "$("$jq" -r '.error' "$cache_path")"
			elif [ "$status" = "search" ]
			then
				"$echo" -e "${BOLD}$("$jq" -r '.results[] | .PackageBase' "$cache_path")${NORMAL}"
			else
				print_err "We've encountered some unexpected results."
				exit 1
			fi
		done
	else
		arg_err
	fi
}

clear_cache() {
	print_warning "Cache files will be cleaned. Be careful!"
	"$rm" -rf "$YapmanCachePath"
	if [ -e "$YapmanCachePath" ]
	then
		print_err "Could not delete the cache files."
		"$echo" -e "You could try to remove them by yourself.
Cache files is here, take a look: ${YapmanCachePath}"
	else
		print_ok "Cache files cleaned."
		"$echo" -e "What a clean space. Yum yum yum... :D"
		"$mkdir" "$YapmanCachePath"
	fi
}

load_config() {
	if [ -e "$YapmanConfigPath" ]
	then
		source "$YapmanConfigPath"
		if [ "$colorful_output" = "false" ]
		then
			BOLD="\033[1m"
			BOLDB="\033[1m"
			BOLDR="\033[1m"
			BOLDG="\033[1m"
			BOLDY="\033[1m"
			NORMAL="\033[0m"
		fi
		if [ "$bold_output" = "false" ]
		then
			BOLD="\033[0m"
			BOLDB="\033[0;34m"
			BOLDR="\033[0;31m"
			BOLDG="\033[0;32m"
			BOLDY="\033[0;33m"
			NORMAL="\033[0m"
		fi
		if [ "$no_visual" = "true" ]
		then
			BOLD="\033[0m"
			BOLDB="\033[0m"
			BOLDR="\033[0m"
			BOLDG="\033[0m"
			BOLDY="\033[0m"
			NORMAL="\033[0m"
		fi
	fi
}

main "$@"
