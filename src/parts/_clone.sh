#!/usr/bin/env bash
clone_repo() {
	if [ "$#" -eq 1 ]
	then
		"$git" clone -q "${AUR_DOMAIN}/${1}.git" && return 0 || return 1
	fi
}
