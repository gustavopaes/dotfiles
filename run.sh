#!/bin/sh

##
## Execute with sudo.
##
## Before run, update all download urls
##

NODE_URL="http://nodejs.org/dist/v0.12.3/node-v0.12.3.tar.gz"
SUBLIME_URL="http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb"

## end
if [ "$(whoami)" != "root" ]; then
	echo "Please run as root"
	exit
fi

ORIG=`pwd`

## Update system
echo "Updating system (apt-get upgrade)"
apt-get -qq update
apt-get -qq  -y upgrade

## Install c++
echo "Installing gcc, c++ (build-essential)"
apt-get -qq -y install build-essential

## Install and configure GIT
echo "Installing GIT"
apt-get -qq -y install git

## Install VLC
apt-get -qq -y install vlc

## SUBLIME JS
SUBL=`whereis subl | grep subl$`

if test -z "$SUBL"; then
	echo "Installing Sublime Text 3"

	wget --output-document=sublime-text.deb $SUBLIME_URL
	dpkg -i sublime-text.deb

	## remove temp files
	rm sublime-text.deb
fi

## NODE JS
NODE=`whereis node | grep node$`

if test -z "$NODE"; then
	echo "Installing nodejs..."

	wget --output-document=node.tar.gz $NODE_URL
	tar xf node.tar.gz && rm node.tar.gz
	
	mv node-* /usr/local/src/node && cd /usr/local/src/node/

	./configure --prefix=/usr/local/
	make && make install

	cd $ORIG
fi

## GO LANG
if [ ! -d "/usr/local/src/go/src" ]; then
	echo "Installing golang..."

	git clone https://github.com/golang/go.git /usr/local/src/go
	cd /usr/local/src/go
	git checkout go1.4.2
	cd src/ && ./all.bash

	ln -s /usr/local/src/go/bin/go /usr/bin/go
fi

cd $ORIG


## Configure GIT
echo "Git config..."
cp dotfiles/.gitconfig $HOME/.gitconfig
chown $USER:$USER $HOME/.gitconfig

## Profile file
echo "Profile config..."
cp dotfiles/.profile $HOME/.profile
chown $USER:$USER $HOME/.profile

## Bash file
echo "Bash config..."
cp dotfiles/.bashrc $HOME/.bashrc
chown $USER:$USER $HOME/.bashrc

## Sublime User preferences
echo "Sublime user preferences..."
cp dotfiles/Preferences.sublime-settings $HOME/.config/sublime-text-3/Packages

echo "All Ready. Reboot your system."

exit 1
