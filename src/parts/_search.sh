#!/usr/bin/env bash
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
