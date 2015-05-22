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

## Update system
echo "Updating system (apt-get)"
apt-get -qq update
apt-get -qq  -y upgrade

## Install XFCE
echo "Installing XFCE (xubuntu-desktop)"
apt-get -y -qq install xubuntu-desktop

## Install c++
echo "Installing c++"
apt-get -qq -y install c++ binutils

## Install and configure GIT
echo "Installing GIT"
apt-get -qq -y install git

echo -n "Set your name: "
read GIT_NAME

echo -n "Set your e-mail: "
read GIT_EMAIL

git config --global --replace-all user.name  $GIT_NAME
git config --global --replace-all user.email $GIT_EMAIL

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

echo "Done! Be happy."

## Check if golang is installed
exit 1
