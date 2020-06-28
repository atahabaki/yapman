#!/usr/bin/env bash
clear_cache() {
	print_wrn "Cache files will be cleaned. Be careful!"
	"$rm" -rf "$YapmanCachePath"
	if [ -e "$YapmanCachePath" ]
	then
		print_err "Could not delete the cache files."
		"$echo" -e "You could try to remove them by yourself.
Cache files is here, take a look: ${YapmanCachePath}"
	else
		print_ok "Cache files cleaned."
		"$echo" -e "What a clean space. Yum yum yum... :D"
		"$mkdir" "$YapmanCachePath"
	fi
}

