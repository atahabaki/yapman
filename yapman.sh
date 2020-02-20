#/usr/bin/env bash
GREEN='\033[0;32m'
NORMAL='\033[0m'
RED='\033[0;31m'
YELLOW='\033[0;33m'

OK="[${GREEN}OK!${NORMAL}]"
ERR="[${RED}ERR${NORMAL}]"
WRN="[${YELLOW}WRN${NORMAL}]"

DIR=`dirname $0`
YapmanPath="${HOME}/ext/aur"

#if [ -e "${DIR}/conf.sh" ]
#then
#	echo -e "${OK} config is ready and placed."
#else
#	echo -e "${ERR} config file is not found."
#	exit 127
#fi

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

yuppack() {
	FOLDER=$1
	cd $1

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
					echo -e "\n${OK} Installing '${PACKDIR}'...\n"
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
					echo -e "\n${OK} Installing '${PACKDIR}'...\n"
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
		echo -e "\n${OK} Installing '${PACKDIR}'...\n"
		makepkg 
	fi
}

if [ $# -gt 0 ]
then
	if [ "$1" == "init" ]
	then
		echo -e "\n${OK} Initializing yapman."
		mkdir -p $YapmanPath && echo -e "${OK} ${YapmanPath} created as a container."
	elif [ "$1" == "-Cu" ]
	then
		echo -e "\n${OK} Checking updates..."
		for folder in $YapmanPath/*
		do
			echo -e "Checking updates for $(basename "$folder")"
			cd $folder
			if [ "$(git pull | grep 'Already up to date')" == "Already up to date." ]
			then
				echo -e "${OK} Already up to date."
			else
				echo -e "${WRN} Needs to be updated."
			fi
		done
	elif [ "$1" == "-I" ]
	then
		if [ $# -eq 2 ]
		then
			install $2
		else
			echo -e "${ERR} wrong arguments. See the usage by '--help'" 
			exit 127
		fi
	elif [ "$1" == "-Ic" ]
	then
		if [ $# -eq 2 ]
		then
			install $2 "onlydep"
		else
			echo -e "${ERR} wrong arguments. See the usage by '--help'" 
			exit 127
		fi
	elif [ "$1" == "-Icc" ]
	then
		if [ $# -eq 2 ]
		then
			install $2 "clean"
		else
			echo -e "${ERR} wrong arguments. See the usage by '--help'" 
			exit 127
		fi
	else
		echo "unknown err"
	fi
else
	echo -e "${ERR} at least one argument needs to be passed."
fi


