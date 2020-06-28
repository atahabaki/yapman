#!/usr/bin/env bash
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
