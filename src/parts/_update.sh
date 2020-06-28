#!/usr/bin/env bash
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
				print_wrn "Update it ASAP."
			fi
		fi
	done
}
