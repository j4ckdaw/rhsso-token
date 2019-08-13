#!/bin/bash

BIN_DIR="/usr/bin/"
CONFIG_DIR="/etc/"

# check program was run as root
if [ ! whoami == "root" ]; then
	printf "ERROR: Please run as root.\n"
	exit

# check required folders exist
if [ ! -d $BIN_DIR ]; then
	printf "ERROR: Bin folder does not exist.\n"
	exit
fi

if [ ! -d $CONFIG_DIR ]; then
	printf "ERROR: Config folder does not exist.\n"
	exit
fi

# make config folder
if [ ! -d $CONFIG_DIR"rhsso-token/" ]; then
	mkdir $CONFIG_DIR"rhsso-token/"
fi

# TODO: autocomplete stuff

# TODO: dependencies stuff
