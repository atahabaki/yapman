#!/usr/bin/env bash
BOLD="\033[1m"
BOLDB="\033[1;34m"
BOLDR="\033[1;31m"
BOLDG="\033[1;32m"
BOLDY="\033[1;33m"
NORMAL="\033[0m"
OK="${BOLDG}[OK]${NORMAL}"
ERR="${BOLDR}[ERR]${NORMAL}"
WRN="${BOLDY}[WRN]${NORMAL}"

XDG_CONFIG_HOME="${HOME}/.config/yapman"
XDG_CACHE_HOME="${HOME}/.cache/yapman"
XDG_DATA_HOME="${HOME}/.local/share/yapman"
YapmanConfigPath="${XDG_CONFIG_HOME}/yapman.conf"
YapmanCachePath="${XDG_CACHE_HOME}/"
YapmanPackagePath="${XDG_DATA_HOME}/packages"
YapmanLogsPath="${XDG_CACHE_HOME}/logs"
YapmanExampleConfigPath="${XDG_CONFIG_HOME}/yapman.d.conf"

AUR_DOMAIN="https://aur.archlinux.org"
AUR_BASE_URL="https://aur.archlinux.org/rpc/?v=5&type="
AUR_SEARCH_URL="${AUR_BASE_URL}search&arg="
AUR_INFO_URL="${AUR_BASE_URL}info&arg="

AUTHOR="@atahabaki"
PROGRAM="yapman"
VERSION="2.0.0"
ABBR="Yet Another Package Manager for AUR"