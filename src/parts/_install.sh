#!/usr/bin/env bash
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
