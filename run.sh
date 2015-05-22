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

## Install XFCE
echo "Installing XFCE (xubuntu-desktop)"
apt-get -y -qq install xubuntu-desktop

## Install c++
echo "Installing gcc, c++ (build-essential)"
apt-get -qq -y install build-essential

## Install and configure GIT
echo "Installing GIT"
apt-get -qq -y install git

## Configure GIT
cp dotfiles/.gitconfig $HOME/.gitconfig

## Profile file
cp dotfiles/.profile $HOME/.profile

## Bash file
cp dotfiles/.bashrc $HOME/.bashrc

## SUBLIME JS
SUBL=`whereis subl | grep subl$`

if test -z "$SUBL"; then
	echo "Installing Sublime Text 3"

	wget --directory-prefix=/tmp --output-document=sublime-text.deb $SUBLIME_URL
	dpkg -i /tmp/sublime-text.deb

	## remove temp files
	rm /tmp/sublime-text.deb
fi

## NODE JS
NODE=`whereis node | grep node$`

if test -z "$NODE"; then
	echo "Installing nodejs..."

	wget --directory-prefix=/tmp --output-document=node.tar.gz $NODE_URL
	tar -xf /tmp/node.tar.gz -C /tmp/node
	cp -R /tmp/node/node* /usr/local/src/node
	/usr/local/src/node/.configure --prefix=/usr/local/
	make && make install

	## remove temp files
	rm /tmp/node*

	exit
fi

## GO LANG
if [ ! -d "/usr/local/src/go/src" ]; then
	mkdir "$HOME/gocode"

	cd /usr/local/src/
	git clone https://go.googlesource.com/go
	cd go
	git checkout go1.4.1
	cd src/
	./all.bash
fi

cd $ORIG

echo "All Ready. Reboot your system."

exit 1
