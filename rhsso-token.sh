#!/bin/bash

CONFIG_DIR="/etc/rhsso-token/"

main() {
	FILE=$1.yaml
	if [ ! -f $CONFIG_DIR$FILE ]; then
              printf "ERROR: Failed to load config file."
              exit
      	fi

      	# read parameters from config file 
      	client_id=$(yq r $FILE client_id)
      	username=$(yq r $FILE username) 
	host=$(yq r $FILE host)
	realm=$(yq r $FILE realm)

       	# get sensitive data from user 
       	printf "Enter password:" >&2
       	read -s password
       	printf "\nEnter client_secret:" >&2
       	read -s client_secret
       	printf "\n" >&2

       	# curl the token
       	token=$(curl \ 
		-d "grant_type=password" \
	       	-d "client_id=$client_id" \
	       	-d "client_secret=$client_secret" \
	       	-d "username=$username" \
	       	-d "password=$password" \
	       	$host/auth/realms/$realm/protocol/openid-connect/token \
	       	| jq -r '.access_token')
         
       	printf "$token"
}

show-help() {
	printf "Usage: rhsso-token [OPTION] [NAME]\n"
	printf "Fetches an RHSSO token using a defined config.\n\n"

	printf "OPTIONS:\n"
	printf "  -a, --add       add a token config called NAME\n"
	printf "  -r, --remove    remove the token config called NAME\n"
	printf "  -l, --list      list all token configs\n"
	printf "  -h, --help      display this help and exit\n\n"

	printf "EXAMPLES:\n"
	printf "  rhsso-token -a foo        add a token config called 'foo'\n"
	printf "  rhsso-token -r bar        remove the token config called 'bar'\n"
	printf "  rhsso-token -l            list all token configs\n"
	printf "  TOKEN=\$(rhsso-token baz)  get token using config 'baz'\n"
	printf "                            and store it in \$TOKEN\n"
}

list-configs() {
	FILES=$CONFIG_DIR*
	for f in $FILES; do
		basename $f .yaml
	done
}

add-config() {
	FILE=$1.yaml
	if [ -f $CONFIG_DIR$FILE ]; then
		printf "ERROR: token config with this name exists already.\n"
		printf "You can remove it with 'rhsso-token -r NAME\n"
		exit
	else 
		printf "Enter client_id: "
        	read -s client_id
        	printf "\nEnter username: "
        	read -s username
		printf "\nEnter host: "
		read -s host
		printf "\nEnter realm: "
		read -s realm
        	printf "\n"

		echo "\"client_id\": \"$client_id\"" > $CONFIG_DIR$FILE
		echo "\"username\": \"$username\"" > $CONFIG_DIR$FILE
		echo "\"host\": \"$host\"" > $CONFIG_DIR$FILE
		echo "\"realm\": \"$realm\"" > $CONFIG_DIR$FILE

		printf "Added token config."	
	fi
}

remove-config() {
	FILE=$1.yaml
        if [ ! -f $CONFIG_DIR$FILE ]; then
              printf "ERROR: No such token config exists.\n"
              exit
        fi
	rm $CONFIG_DIR$FILE
	printf "Removed token config: $1\n"
	exit
}

if [ $1 == "-h" ] || [ $1 == "--help" ]; then
	show-help	
	exit
elif [ $1 == "-l" ] || [ $1 == "--list" ]; then
	list-configs
	exit
elif [ $1 == "-a" ] || [ $1 == "--add" ]; then
	add-config $2
	exit
elif [ $1 == "-r" ] || [ $1 == "--remove" ]; then
	remove-config $2
	exit
elif [[ $1 == -* ]]; then
	printf "rhsso-token: invalid option.\n" >&2
	printf "Try 'rhsso-token --help' for more information.\n" >&2
	exit
else 
       main $1 
       exit
fi
