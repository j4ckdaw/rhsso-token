#!/bin/bash

BIN_DIR="/usr/bin/"
CONFIG_DIR="/etc/"

# check program was run as root
user=$(whoami)
if [ ! $user == "root" ]; then
	printf "ERROR: Please run as root.\n"
	exit
fi

# check required folders exist
if [ ! -d $BIN_DIR ]; then
	printf "ERROR: Bin folder does not exist.\n"
	exit
fi

if [ ! -d $CONFIG_DIR ]; then
	printf "ERROR: Config folder does not exist.\n"
	exit
fi

# make token configs folder
if [ ! -d $CONFIG_DIR"rhsso-token/" ]; then
	mkdir $CONFIG_DIR"rhsso-token/"
	printf "Created token config directory in /etc/\n"
fi

# put executable on path and make it usable
cp rhsso-token.sh $BIN_DIR'rhsso-token'
chmod +x $BIN_DIR'rhsso-token'

# TODO: autocomplete stuff

# TODO: dependencies stuff
