#!/usr/bin/env bash
load_config() {
	if [ -e "$YapmanConfigPath" ]
	then
		source "$YapmanConfigPath"
		if [ "$colorful_output" = "false" ]
		then
			BOLD="\033[1m"
			BOLDB="\033[1m"
			BOLDR="\033[1m"
			BOLDG="\033[1m"
			BOLDY="\033[1m"
			NORMAL="\033[0m"
		fi
		if [ "$bold_output" = "false" ]
		then
			BOLD="\033[0m"
			BOLDB="\033[0;34m"
			BOLDR="\033[0;31m"
			BOLDG="\033[0;32m"
			BOLDY="\033[0;33m"
			NORMAL="\033[0m"
		fi
		if [ "$no_visual" = "true" ]
		then
			BOLD="\033[0m"
			BOLDB="\033[0m"
			BOLDR="\033[0m"
			BOLDG="\033[0m"
			BOLDY="\033[0m"
			NORMAL="\033[0m"
		fi
	fi
}
