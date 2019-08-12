#!/bin/bash

main() {
	# read parameters from config file
        client_id=$(yq r $1 client_id)
        username=$(yq r $1 username)
        host=$(yq r $1 host)
        realm=$(yq r $1 realm)

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
 
if [[ $1 != *.yaml ]] && [[ $1 != *.yml ]]; then
	FILE=$1.yaml
else
	FILE=$1
fi

if [ ! -f $FILE ]; then
              echo "Config file does not exist."
              exit
fi

main $FILE
