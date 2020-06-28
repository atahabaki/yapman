#!/usr/bin/env bash
remove_package() {
	if [ $# -ge 1 ]
	then
		for package in "$@"
		do
			print_wrn "Removing ${BOLDB}${package}${NORMAL}"
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
				if confirm "Delete downloaded folder too?"
				then
					print_ok "Removing the folder"
					rm -rf "${YapmanPackagePath}/${package}" && print_ok "Removed."
				else
					print_wrn "So be it..."
				fi
			else
				print_err "Abort."
			fi
		done
	else
		arg_err
	fi
}
