#!/usr/bin/env bash
initialize() {
	"$mkdir" -p "$YapmanCachePath" "$YapmanLogsPath" "$YapmanPackagePath" "$XDG_CONFIG_HOME" && print_ok "Necessary folders has been created."
	"$touch" "$YapmanConfigPath" && print_ok "Config file has been successfully created."
	print_ok "Initialized yapman. Enjoy now!.."
}

init() {
	if [ -d "$YapmanCachePath" ] | [ -e "$YapmanConfigPath" ] | [ -d "$YapmanLogsPath" ] | [ -d "$YapmanPackagePath" ]
	then
		print_wrn "Already initialized."
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

