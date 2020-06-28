#/usr/bin/env bash
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
