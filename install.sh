#!/bin/bash

BIN_DIR="/usr/local/bin/"
CONFIG_DIR="$HOME/.rhsso-token/"

# check program was run as root
user=$(whoami)
if [ ! $user == "root" ]; then
	printf "ERROR: Please run as root.\n"
	exit
fi

# check bin directory exists
if [ ! -d $BIN_DIR ]; then
	printf "ERROR: Bin directory: $BIN_DIR does not exist.\n"
	exit
fi

# make token configs directory
if [ ! -d $CONFIG_DIR ]; then
	mkdir -p $CONFIG_DIR
	chown -R $SUDO_USER:$SUDO_USER $CONFIG_DIR
	if [ -d $CONFIG_DIR ]; then
		printf "Created configs directory: $CONFIG_DIR\n"
	else
		printf "ERROR: Failed to create configs directory: $CONFIG_DIR\n"
		exit
	fi
else
	printf "Config directory: $CONFIG_DIR already exists\n"
fi

# put scrpit on path and make it executable
executable_location=$BIN_DIR'rhsso-token'

cp rhsso-token.sh $executable_location
if [ -f "$executable_location" ]; then
        printf "Script copied onto path\n"
else 
	printf "ERROR: Failed to copy script to path\n"
	exit
fi

chmod +x $executable_location
if [[ -x "$executable_location" ]]; then
	printf "Script made executable\n"
else 
	printf "ERROR: Failed to make script executable\n"
	exit
fi
printf "Installation complete\n"

# TODO: dependencies stuff
