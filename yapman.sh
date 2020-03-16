#/usr/bin/env bash
BOLD="\033[1m"
BOLDB="\033[1;34m"
BOLDR="\033[1;31m"
BOLDG="\033[1;32m"
BOLDY="\033[1;33m"
NORMAL="\033[0m"
OK="${BOLDG}[OK]${NORMAL}"
ERR="${BOLDR}[ERR]${NORMAL}"
WRN="${BOLDY}[WRN]${NORMAL}"

YapmanPath="${HOME}/.yapman"
YapmanConfigPath="${YapmanPath}/yapman.conf"
YapmanCachePath="${YapmanPath}/cache"
YapmanPackagePath="${YapmanPath}/packages"

AUTHOR="@atahabaki"
PROGRAM="yapman"
VERSION="2.0.0"
ABBR="Yet Another Package Manager for AUR"

intro() {
	echo -e "${BOLDB}${PROGRAM}${NORMAL} version ${BOLDG}${VERSION}${NORMAL} by ${BOLDR}${AUTHOR}${NORMAL}"
	echo -e "${BOLD}${ABBR}${NORMAL}\n"
}

print_err() {
	if [ $# -eq 1 ]
	then
		echo -e "${ERR} $1"
	else
		echo -e "${ERR} Unknown error occured!"
	fi
}

print_ok() {
	if [ $# -eq 1 ]
	then
		echo -e "${OK} $1"
	else
		echo -e "${OK} Everything is fine!"
	fi
}

print_warning() {
	if [ $# -eq 1 ]
	then
		echo -e "${WRN} $1"
	else
		echo -e "${WRN} Something idk happenening!"
	fi
}

arg_err() {
	print_err "Missing or extra argument.\n"
	if [ $# -eq 1 ]
	then
		help_command $1
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
	mkdir -p $YapmanPath $YapmanCachePath $YapmanPackagePath && print_ok "Necessary folders has been created."
	touch $YapmanConfigPath && print_ok "Config file has been successfully created."
	print_ok "Initialized yapman. Enjoy now!.."
}

init() {
	if [ -d $YapmanPath ]
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
	echo -e $VERSION
}

usage() {
	echo -e "${BOLD}USAGE:${NORMAL}\nyapman.sh <operation> [...]"
	echo -e "${BOLD}Operations:${NORMAL}"
	echo -e "  {init}"
	echo -e "  {-u update}"
	echo -e "  {-i install} <package(s)>"
	echo -e "  {-g get} <package(s)>"
	echo -e "  {info} <package(s)>"
	echo -e "  {-r remove} <package(s)>"
	echo -e "  {-s search} <package(s)>"
	echo -e "  {-c clear-cache}"
	echo -e "  {-v --version}"
	echo -e "  {-h --help}"
	echo -e "\nUse 'yapman.sh {-h --help}' with an operation for available options."
}



help_command() {
	if [ $# -eq 1 ]
	then
		case $1 in
			"search_package")
				echo -e ""
				;;
			*)
				usage
				;;
		esac
	else
		usage
	fi
}

search_package() {
	if [ $# -ge 1 ]
	then
		for package in $@
		do
			print_ok "Searhing ${BOLDB}${package}${NORMAL}"
		done
	else
		arg_err
	fi
}

main() {
	if [ -e YapmanConfigPath ]
	then
		source $YapmanConfigPath
	fi
	if [ $# -ge 1 ]
	then
		if [ "$1" != "-v" ] && [ "$1" != "--version" ]
		then
			intro
		fi
		case $1 in
			"-v" | "--version") version;;
			"-h" | "--help") 
				help_command
				;;
			"init")
				init
				;;
		esac
	else
		intro
		arg_err
	fi
}

main $@