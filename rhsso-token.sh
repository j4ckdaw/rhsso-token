#!/bin/bash

CONFIG_DIR="$HOME/.rhsso-token/"

main() {
    FILE=$1.yaml
    # check token config file exists
  	if [ ! -f $CONFIG_DIR$FILE ]; then
        printf "ERROR: Failed to load token config: '$1'\n"
        printf "Run 'rhsso-token --help' for usage"
        exit
    fi

    # read parameters from config file
    client_id=$(yq r $CONFIG_DIR$FILE client_id)
    username=$(yq r $CONFIG_DIR$FILE username) 
    host=$(yq r $CONFIG_DIR$FILE host)
    realm=$(yq r $CONFIG_DIR$FILE realm)

    # get sensitive data from user
    read -s -p "Enter password:" password
    read -s -p "\nEnter client_secret:" client_secret
    printf "\n" >&2

    # curl the token
    token=$(curl \
            -d "grant_type=password" \
            -d "client_id=$client_id" \
            -d "client_secret=$client_secret" \
            -d "username=$username" \
            -d "password=$password" \
            "$host/auth/realms/$realm/protocol/openid-connect/token" \
            | jq -r '.access_token')
         
    printf "$token"
}

show-help() {
    printf "Usage: rhsso-token [OPTIONS] [NAME]\n"
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
    if [ ! "$(ls -A $CONFIG_DIR)" ]; then
	  printf "No token configs to list.\n"  
    else 
    	FILES=$CONFIG_DIR'*'
    	for f in $FILES; do
            basename $f .yaml
    	done
    fi
}

add-config() {
    if [ -z "$1" ]; then
        printf "No name specified for new token config.\n"
        printf "Try 'rhsso-token --help' for more information.\n"
        exit
    fi 

    FILE=$1.yaml
    if [ -f $CONFIG_DIR$FILE ]; then
        printf "ERROR: token config with this name exists already.\n"
        printf "You can remove it with 'rhsso-token -r NAME\n"
        exit
    else 
        read -p "Enter client_id: " client_id
        read -p "Enter username: " username
        read -p "Enter host: " host
        read -p "Enter realm: " realm

        echo "\"client_id\": \"$client_id\"" > $CONFIG_DIR$FILE
        echo "\"username\": \"$username\"" >> $CONFIG_DIR$FILE
        echo "\"host\": \"$host\"" >> $CONFIG_DIR$FILE
        echo "\"realm\": \"$realm\"" >> $CONFIG_DIR$FILE

    printf "Added token config.\n"	
  fi
}

remove-config() {
    if [ -z "$1" ]; then 
	printf "Please specify a token config to remove.\n"
	printf "Try 'rhsso-token --help' for more information.\n"
    	exit
    fi

    FILE=$1.yaml
    if [ ! -f $CONFIG_DIR$FILE ]; then
        printf "ERROR: No such token config exists.\n"
        exit
    fi

    rm $CONFIG_DIR$FILE
    if [ ! -f $CONFIG_DIR$FILE ]; then
       printf "Removed token config: $1\n"
    else
       printf "Failed to remove token config: $1\n"
    fi
}

ensure-config-dir() {
    if [ ! -d $CONFIG_DIR ]; then
    	printf "ERROR: Could not find token config directory.\n"
    	exit
    fi
}

if [ -z "$1" ]; then
    printf "rhsso-token: no arguments specified.\n"
    printf "Try 'rhsso-token --help' for more information.\n"
    exit
elif [ $1 == "-h" ] || [ $1 == "--help" ]; then
    show-help	
    exit
elif [ $1 == "-l" ] || [ $1 == "--list" ]; then
    ensure-config-dir
    list-configs
    exit
elif [ $1 == "-a" ] || [ $1 == "--add" ]; then
    ensure-config-dir
    add-config $2
    exit
elif [ $1 == "-r" ] || [ $1 == "--remove" ]; then
    ensure-config-dir
    remove-config $2
    exit
elif [[ $1 == -* ]]; then
    printf "rhsso-token: invalid option.\n" >&2
    printf "Try 'rhsso-token --help' for more information.\n" >&2
    exit
else
    ensure-config-dir 
    main $1 
    exit
fi

#========
# RUN LOGS
# ┌─[sfish@nimbus] - [~/Code/Personal/rhsso-token] - [10048]
# └─[$] rhsso-token.sh
# /Users/sfish/Code/Personal/scripts/rhsso-token.sh: line 107: [: ==: unary operator expected
# /Users/sfish/Code/Personal/scripts/rhsso-token.sh: line 107: [: ==: unary operator expected
# /Users/sfish/Code/Personal/scripts/rhsso-token.sh: line 110: [: ==: unary operator expected
# /Users/sfish/Code/Personal/scripts/rhsso-token.sh: line 110: [: ==: unary operator expected
# /Users/sfish/Code/Personal/scripts/rhsso-token.sh: line 113: [: ==: unary operator expected
# /Users/sfish/Code/Personal/scripts/rhsso-token.sh: line 113: [: ==: unary operator expected
# /Users/sfish/Code/Personal/scripts/rhsso-token.sh: line 116: [: ==: unary operator expected
# /Users/sfish/Code/Personal/scripts/rhsso-token.sh: line 116: [: ==: unary operator expected
# ERROR: Failed to load config file.%
