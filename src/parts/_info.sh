#!/usr/bin/env bash
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
