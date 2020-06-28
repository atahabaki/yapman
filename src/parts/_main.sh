#!/usr/bin/env bash
main() {
	can_run
	load_config
	if [ "$#" -ge 1 ]
	then
		if [ "$1" != "-v" ] && [ "$1" != "version" ]
		then
			intro
		fi
		case "$1" in
			"init") init;;
			"-u" | "update") update;;
			"-i" | "install")
				install_package "${@:2}"
				;;
			"-g" | "get")
				get_package "${@:2}"
				;;
			"-a" | "info")
				get_package_info "${@:2}"
				;;
			"-r" | "remove")
				remove_package ${@:2}
				;;
			"-s" | "search")
				search_package "${@:2}"
				;;
  			"-c" | "clear-cache") clear_cache;;
			"-v" | "version") version;;
			"-h" | "help")
				help_command "${@:2}"
				;;
			*) arg_err;;
		esac
	else
		intro && arg_err
	fi
}

