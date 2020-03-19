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

AUR_BASE_URL="https://aur.archlinux.org/rpc/?v=5&type="
AUR_SEARCH_URL="${AUR_BASE_URL}search&arg="
AUR_INFO_URL="${AUR_BASE_URL}info&arg="

AUTHOR="@atahabaki"
PROGRAM="yapman"
VERSION="2.0.0"
ABBR="Yet Another Package Manager for AUR"

intro() {
	echo -e "${BOLDB}${PROGRAM}${NORMAL} version ${BOLDG}${VERSION}${NORMAL} by ${BOLDR}${AUTHOR}${NORMAL}"
	echo -e "${BOLD}${ABBR}${NORMAL}\n"
}

can_run() {
	echo -e "${BOLD}Checking dependencies...${NORMAL}"
	if [ -e "$(which pacman)" ]
	then
		print_ok "${BOLD}pacman${NORMAL} is installed."
	else
		print_err "${BOLD}pacman${NORMAL} is not installed. You need it to run this."
		exit 127
	fi
	if [ -e "$(which jq)" ]
	then
		print_ok "${BOLD}jq${NORMAL} is installed."
	else
		print_err "${BOLD}jq${NORMAL} is not installed. You need it to run this."
		exit 127
	fi
	if [ -e "$(which bash)" ]
	then
		print_ok "${BOLD}bash${NORMAL} is installed."
	else
		print_err "${BOLD}bash${NORMAL} is not installed. You need it to run this."
		exit 127
	fi
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
			local cache_path="${YapmanCachePath}/search_results_${package}.json"
			curl -s -o $cache_path "${AUR_SEARCH_URL}${package}"
			local status=$(jq -r '.type' $cache_path)
			if [ "$status" = "error" ]
			then
				print_err "$(jq -r '.error' $cache_path)"
			elif [ "$status" = "search" ]
			then
				echo -e "${BOLD}$(jq -r '.results[] | .PackageBase' $cache_path)${NORMAL}"
			else
				print_err "We've encountered some unexpected results."
				exit 1
			fi
		done
	else
		arg_err
	fi
}

get_package_info() {
	if [ $# -ge 1 ]
	then
		for package in $@
		do
			print_ok "Getting info 4 ${BOLDB}${package}${NORMAL}"
			local cache_path="${YapmanCachePath}/info_${package}.json"
			curl -s -o $cache_path "${AUR_INFO_URL}${package}"
			local status=$(jq -r '.type' $cache_path)
			if [ "$status" = "error" ]
			then
				print_err "$(jq -r '.error' $cache_path)"
			elif [ "$status" = "multiinfo" ]
			then
				echo -e "$(jq -r '.results[] | to_entries[] | "\u001b[1m\(.key):\u001b[0m \(.value)"' $cache_path)"
			else
				print_err "We've encountered some unexpected results."
				exit 1
			fi
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
		if [ "$1" != "-v" ] && [ "$1" != "version" ]
		then
			intro
			can_run && echo
		fi
		case $1 in
			"-v" | "version") version;;
			"-h" | "help") 
				help_command
				;;
			"-s" | "search")
				search_package ${@:2}
				;;
			"info")
				get_package_info ${@:2}
				;;
			"init")
				init
				;;
		esac
	else
		intro
		can_run && echo
		arg_err
	fi
}

main $@