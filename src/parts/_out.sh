#!/usr/bin/env bash
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

print_wrn() {
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

intro() {
	"$echo" -e "${BOLDB}${PROGRAM}${NORMAL} version ${BOLDG}${VERSION}${NORMAL} by ${BOLDR}${AUTHOR}${NORMAL}"
	"$echo" -e "${BOLD}${ABBR}${NORMAL}\n"
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
