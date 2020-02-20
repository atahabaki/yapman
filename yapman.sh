OK='\033[0;32m'
NC='\033[0m'
ERR='\033[0;31m'
WRN='\033[0;33m'

if [ -e "$(which pacman)" ]
then
	echo -e "[${OK}OK${NC}] pacman is installed."
else
	echo -e "[${ERR}ERR${NC}] pacman is not installed!"
	exit 127
fi

if [ -e "$(which makepkg)" ]
then
	echo -e "[${OK}OK${NC}] makepkg is installed."
else
	echo -e "[${ERR}ERR${NC}] makepkg is not installed!"
	exit 127
fi

if [ -e "$(which git)" ]
then
	echo -e "[${OK}OK${NC}] git is installed."
else
	echo -e "[${ERR}ERR${NC}] git is not installed!"
	exit 127
fi
