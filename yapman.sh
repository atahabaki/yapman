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

DIR=`dirname $0`
YapmanPath="${HOME}/ext/aur"

AUTHOR="@atahabaki"
PROGRAM="yapman"
ABBR="Yet Another Package Manager for AUR"

intro() {
	echo -e "${BOLDG}${PROGRAM}${NORMAL} by ${BOLDR}${AUTHOR}${NORMAL}"
	echo -e "${BOLD}${ABBR}${NORMAL}\n"
}

arg_err() {
	echo -e "${ERR} wrong arguments. See the usage by '-h'" 
	exit 127
}

usage() {
	if [ $# -eq 0 ]
	then
		echo -e "${BOLD}Usage:${NORMAL}\n"
		echo -e "-C<u:f>   :Checks update or show results for filter."
		echo -e "-I[c:cc]  :Installs the package."
		echo -e "-R[c:cc]  :Removes the package."
	else
		if [ "$1" == "-I" ]
		then
			echo -e "${BOLD}Usage:\t${NORMAL}I[c:cc]\n"
			echo -e "-c        :clean install mode."
			echo -e "-cc       :complete clean install mode."
		elif [ "$1" == "-C" ]
		then
			echo -e "${BOLD}Usage:\t${NORMAL}C<u:f>\n"
			echo -e "-u        :Checks for update."
			echo -e "-f        :Filters installed packages."
		elif [ "$1" == "-R" ]
		then
			echo -e "${BOLD}Usage:\t${NORMAL}R[c:cc]\n"
			echo -e "-c        :clean remove mode."
			echo -e "-cc       :complete clean remove mode."
		fi
	fi
}

check_deps() {
	if [ -e "$(which pacman)" ]
	then
		echo -e "${OK} pacman is installed."
	else
		echo -e "${ERR} pacman is not installed!"
		exit 127
	fi

	if [ -e "$(which makepkg)" ]
	then
		echo -e "${OK} makepkg is installed."
	else
		echo -e "${ERR} makepkg is not installed!"
		exit 127
	fi

	if [ -e "$(which git)" ]
	then
		echo -e "${OK} git is installed."
	else
		echo -e "${ERR} git is not installed!"
		exit 127
	fi
}

install() {
	URI=$1
	cd $YapmanPath
	pwd
	PACKDIR="$(echo $URI | sed 's/https:\/\/aur.archlinux.org\///' | sed 's/.git//')"
	echo -e "${OK} Ready for '$PACKDIR'..."
	git clone $URI
	cd $PACKDIR
	if [ $# -eq 2 ]
	then
		if [ "$2" == "clean" ]
		then
			echo -e "\n${WRN} Running in complete clean mode."
			read -r -p "Are you Sure? [Y/n] " resp
			case "$resp" in 
				[yY]|"")
					echo -e "\n${OK} Installing ${BOLDG}'${PACKDIR}'${NORMAL}...\n"
					makepkg -sirc
					;;
				[nN])
					echo -e "${ERR} Aborting..."
					exit 130
					;;
			esac
			cd ..
			echo -e "${OK} Removing '${PACKDIR}' folder too..."
			rm -rf $PACKDIR && echo -e "${OK} Done!.."
		elif [ "$2" == "onlydep" ]
		then
			echo -e "\n${WRN} Running in clean mode."
			read -r -p "Are you Sure? [Y/n] " resp
			case "$resp" in 
				[yY]|"")
					echo -e "\n${OK} Installing ${BOLDG}'${PACKDIR}'${NORMAL}...\n"
					makepkg -sirc
					;;
				[nN])
					echo -e "${ERR} Aborting..."
					exit 130
					;;
			esac
		fi
	else
		echo -e "\n${OK} Running in normal mode."
		echo -e "\n${OK} Installing ${BOLDG}'${PACKDIR}'${NORMAL}...\n"
		makepkg 
	fi
}

check_update() {
	echo -e "\n${OK}Checking updates..."
	for folder in $YapmanPath/*
	do
		echo -e "Checking updates for ${BOLDB}$(basename "$folder")${NORMAL}"
		cd $folder
		if [ "$(git pull | grep 'Already up to date')" == "Already up to date." ]
		then
			echo -e "${OK} Already up to date."
		else
			echo -e "${WRN} Needs to be updated."
			read -r -p "Update now? [Y/n] " resp
			case "$resp" in
				[Yy]"")
					echo -e "${OK} Updating $folder..."
					read -r -p "Which mode \"Complete Clean\", \"Clean\", \"Normal\"? [C/d/n] " resp
					case $resp in
						[Cc]"")
							echo -e "${WRN} Running in complete clean install mode."
							makepkg -sirc
							;;
						[Dd])
							echo -e "${WRN} Running in clean install mode."
							makepkg -sirc
							cd ..
							echo -e "${OK} Removing '${folder}' folder too..."
							rm -rf $folder && echo -e "${OK} Done!.."
							;;
						[Nn])
							echo -e "${OK} Running in normal install mode."
							makepkg
							;;
					esac
					;;
				[Nn])
					echo -e "${WRN} Update ASAP."
					;;
			esac
		fi
	done
}

main() {
	if [ $# -gt 0 ]
	then
		if [ $# -eq 2 ]
		then
			case "$1" in
				"-I")
					install $2
					;;
				"-Ic")
					install $2 "onlydep"
					;;
				"-Icc")
					install $2 "clean"
					;;
				"-R")
					echo "remove"
					;;
				"-Rc")
					echo "clean remove"
					;;
				"-Rcc")
					echo "complete clean remove"
					;;
				"-h")
					usage $2
					;;
				*)
					usage
			esac
		elif [ $# -eq 1 ]
		then
			case "$1" in
				"-Cu")
					check_update
					;;
				"-Cf")
					echo "check filter"
					;;
				"-h")
					usage
					;;
				*)
					usage
			esac
		else
			usage
		fi
	else
		arg_err
	fi
}

intro
main $@
