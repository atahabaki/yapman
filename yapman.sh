#!/usr/bin/env bash
BOLD="\033[1m"
BOLDB="\033[1;34m"
BOLDR="\033[1;31m"
BOLDG="\033[1;32m"
BOLDY="\033[1;33m"
NORMAL="\033[0m"
OK="${BOLDG}[OK]${NORMAL}"
ERR="${BOLDR}[ERR]${NORMAL}"
WRN="${BOLDY}[WRN]${NORMAL}"

XDG_CONFIG_HOME="${HOME}/.config/yapman"
XDG_CACHE_HOME="${HOME}/.cache/yapman"
XDG_DATA_HOME="${HOME}/.local/share/yapman"
YapmanConfigPath="${XDG_CONFIG_HOME}/yapman.conf"
YapmanCachePath="${XDG_CACHE_HOME}/"
YapmanPackagePath="${XDG_DATA_HOME}/packages"
YapmanLogsPath="${XDG_CACHE_HOME}/logs"

AUR_DOMAIN="https://aur.archlinux.org"
AUR_BASE_URL="https://aur.archlinux.org/rpc/?v=5&type="
AUR_SEARCH_URL="${AUR_BASE_URL}search&arg="
AUR_INFO_URL="${AUR_BASE_URL}info&arg="

AUTHOR="@atahabaki"
PROGRAM="yapman"
VERSION="2.0.0"
ABBR="Yet Another Package Manager for AUR"

intro() {
	"$echo" -e "${BOLDB}${PROGRAM}${NORMAL} version ${BOLDG}${VERSION}${NORMAL} by ${BOLDR}${AUTHOR}${NORMAL}"
	"$echo" -e "${BOLD}${ABBR}${NORMAL}\n"
}

can_run() {
	if [ -e "$(which sudo)" ]
	then
		sudo="$(which sudo)"
	else
		print_err "${BOLD}sudo${NORMAL} is not installed. You need it to run this."
		exit 127
	fi
	if [ -e "$(which pacman)" ]
	then
		pacman="$(which pacman)"
	else
		print_err "${BOLD}pacman${NORMAL} is not installed. You need it to run this."
		exit 127
	fi
	if [ -e "$(which makepkg)" ]
	then
		makepkg="$(which makepkg)"
	else
		print_err "${BOLD}makepkg${NORMAL} is not installed. You need it to run this."
		exit 127
	fi
	if [ -e "$(which jq)" ]
	then
		jq="$(which jq)"
	else
		print_err "${BOLD}jq${NORMAL} is not installed. You need it to run this."
		exit 127
	fi
	if [ -e "$(which git)" ]
	then
		git="$(which git)"
	else
		print_err "${BOLD}git${NORMAL} is not installed. You need it to run this."
		exit 127
	fi
	if [ -e "$(which bash)" ]
	then
		bash="$(which bash)"
	else
		print_err "${BOLD}bash${NORMAL} is not installed. You need it to run this."
		exit 127
	fi
	if [ -e "$(which mkdir)" ]
	then
		mkdir="$(which mkdir)"
	else
		print_err "${BOLD}mkdir${NORMAL} is not installed. You need it to run this."
	fi
	if [ -e "$(which rm)" ]
	then
		rm="$(which rm)"
	else
		print_err "${BOLD}rm${NORMAL} is not installed. You need it to run this."
	fi
	if [ -e "$(which touch)" ]
	then
		touch="$(which touch)"
	else
		print_err "${BOLD}touch${NORMAL} is not installed. You need it to run this."
	fi	
	if [ -e "$(which echo)" ]
	then
		echo="$(which echo)"
	else
		print_err "${BOLD}echo${NORMAL} is not installed. You need it to run this."
	fi	
}

print_err() {
	if [ $# -eq 1 ]
	then
		"$echo" -e "${ERR} $1"
	else
		"$echo" -e "${ERR} Unknown error occured!"
	fi
}

print_ok() {
	if [ $# -eq 1 ]
	then
		"$echo" -e "${OK} $1"
	else
		"$echo" -e "${OK} Everything is fine!"
	fi
}

print_warning() {
	if [ $# -eq 1 ]
	then
		"$echo" -e "${WRN} $1"
	else
		"$echo" -e "${WRN} Something idk happenening!"
	fi
}

arg_err() {
	print_err "Missing or extra argument.\n"
	if [ $# -eq 1 ]
	then
		help_command "$1"
	else
		help_command
	fi
	exit 127
}

abort() {
	print_err "Abort."
	exit 130
}

confirm() {
	read -r -p "$1 [Y/n] " resp
	case $resp in
		[Yy] | "")
			return 0
			;;
		[Nn])
			return 1
			;;
		*)
			confirm "$1"
			;;
	esac
}

initialize() {
	"$mkdir" -p "$YapmanCachePath" "$YapmanLogsPath" "$YapmanPackagePath" "$XDG_CONFIG_HOME" && print_ok "Necessary folders has been created."
	"$touch" "$YapmanConfigPath" && print_ok "Config file has been successfully created."
	print_ok "Initialized yapman. Enjoy now!.."
}

init() {
	if [ -d "$YapmanCachePath" ] | [ -e "$YapmanConfigPath" ] | [ -d "$YapmanLogsPath" ] | [ -d "$YapmanPackagePath" ]
	then
		print_warning "Already initialized."
		if confirm "Re-initialize?"
		then
			initialize
		else
			abort
		fi
	else
		initialize
	fi
	exit 0
}

version() {
	"$echo" -e $VERSION
}

usage() {
	"$echo" -e "${BOLD}USAGE:${NORMAL}\nyapman.sh <operation> [...]
${BOLD}Operations:${NORMAL}
  {init}
  {-u update}
  {-i install} <package(s)>
  {-g get} <package(s)>
  {-a info} <package(s)>
  {-r remove} <package(s)>
  {-s search} <package(s)>
  {-c clear-cache}
  {-v version}
  {-h help}

Use 'yapman.sh {-h help}' with an operation for available options."
}

help_command() {
	if [ $# -eq 1 ]
	then
		case $1 in
			"search_package")
				"$echo" -e ""
				;;
			*)
				usage
				;;
		esac
	else
		usage
	fi
}

clone_repo() {
	if [ $# -eq 1 ]
	then
		"$git" clone -q "${AUR_DOMAIN}/${1}.git" && return 0 || return 1
	fi
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
				cd "$YapmanPackagePath" || print_err "We couldn't find: ${YapmanPackagePath}" && exit 1
				local package_base="$("$jq" -r '.results[0].PackageBase' "$cache_path")"
				if clone_repo "$package_base"
				then
					cd "$package_base" || exit 1
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

main() {
	can_run
	load_config
	if [ "$#" -ge 1 ]
	then
		if [ "$1" != "-v" ] && [ "$1" != "version" ]
		then
			intro
		fi
		case "$1" in
			"init") init;;
			"-u" | "update") update;;
			"-i" | "install")
				install_package "${@:2}"
				;;
			"-g" | "get")
				get_package "${@:2}"
				;;
			"-a" | "info")
				get_package_info "${@:2}"
				;;
			"-r" | "remove")
				remove_package ${@:2}
				;;
			"-s" | "search")
				search_package "${@:2}"
				;;
  			"-c" | "clear-cache") clear_cache;;
			"-v" | "version") version;;
			"-h" | "help") help_command;;
			*) arg_err;;
		esac
	else
		intro && arg_err
	fi
}

main "$@"