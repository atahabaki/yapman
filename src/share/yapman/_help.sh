#!/usr/bin/env bash
help_command() {
	if [ "$#" -eq 1 ]
	then
		case $1 in
			"init")
				"$echo" -e "${BOLD}USAGE:${NORMAL}
yapman.sh {init}

${BOLD}DEFINITION:${NORMAL}
{init} is used for initializing yapman. Creating directories and config files...

Directories:
Downloaded Packages' Directory: ${YapmanPackagePath}
Cache Directory: ${YapmanCachePath}
Logs' Directory: ${YapmanLogsPath}

Files:
Config File: ${YapmanConfigPath}
Example Config File: ${YapmanExampleConfigPath}
"
				;;
			"-u" | "update")
				"$echo" -e "${BOLD}USAGE:${NORMAL}
yapman.sh {-u update}

${BOLD}DEFINITION:${NORMAL}
{-u update} can be used for checking updates and installing immediatly."
				;;
			"-i" | "install")
				"$echo" -e "${BOLD}USAGE:${NORMAL}
yapman.sh {-i install} <package(s)>

${BOLD}DEFINITION:${NORMAL}
{-i install} for installing package(s)."
				;;
			"-g" | "get")
				"$echo" -e "${BOLD}USAGE:${NORMAL}
yapman.sh {-g get} <package(s)>

${BOLD}DEFINITION:${NORMAL}
{-g get} for getting package(s). Basically, downloads package."
				;;
			"-a" | "info")
				"$echo" -e "${BOLD}USAGE:${NORMAL}
yapman.sh {-a info} <package(s)>

${BOLD}DEFINITION:${NORMAL}
{-a info} for getting information about package(s). Basically, shows information."
				;;
			"-r" | "remove")
				"$echo" -e "${BOLD}USAGE:${NORMAL}
yapman.sh {-r remove} <package(s)>

${BOLD}DEFINITION:${NORMAL}
{-r remove} for removing package(s). Basically uninstalls the package."
				;;
			"-s" | "search")
				"$echo" -e "${BOLD}USAGE:${NORMAL}
yapman.sh {-s search} <package(s)>

${BOLD}DEFINITION:${NORMAL}
{-s search} for searching package(s). In simple terms, trys to find a list of packages that similar to your search."
				;;
			"-c" | "clear-cache")
				"$echo" -e "${BOLD}USAGE:${NORMAL}
yapman.sh {-c clear-cache}

${BOLD}DEFINITION:${NORMAL}
{-c clear-cache} for clearing caches. In simple terms, removes unnecessary files/folders."
				;;
			"-v" | "version")
				"$echo" -e "${BOLD}USAGE:${NORMAL}
yapman.sh {-v version}

${BOLD}DEFINITION:${NORMAL}
{-v version} for couts the version. Simply, shows version of this program."
				;;
			"-h" | "help")
				"$echo" -e "${BOLD}USAGE:${NORMAL}
yapman.sh {-h help} <operation>

${BOLD}DEFINITION:${NORMAL}
{-h help} prints helpful messages like this one. Shows help messages."
				;;
			*)
				usage
				;;
		esac
	else
		usage
	fi
}

usage() {
	"$echo" -e "${BOLD}USAGE:${NORMAL}\nyapman.sh <operation> [...]
${BOLD}Operations:${NORMAL}
  {init}
  {-u update}
  {-i install} <package(s)>
  {-g get} <package(s)>
  {-a info} <package(s)>
  {-r remove} <package(s)>
  {-s search} <package(s)>
  {-c clear-cache}
  {-v version}
  {-h help}

Use 'yapman.sh {-h help}' with an operation for available options."
}
