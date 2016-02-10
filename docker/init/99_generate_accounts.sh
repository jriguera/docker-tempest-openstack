#!/bin/bash

export TEMPEST_AUTH_GENERATEACCOUNTS=${TEMPEST_AUTH_GENERATEACCOUNTS:-false}
if [ "$TEMPEST_AUTH_GENERATEACCOUNTS" == "true" ]; then
    if [ -r $TEMPEST_CONFIG ] && [ -n "$OS_USERNAME" ] && [ -n "$OS_PASSWORD" ] && [ -n "$OS_PROJECT_NAME" ]; then
    	ACCOUNTS=$(sed -ne "s/^test_accounts_file *= *\(.*\)/\1/p" $TEMPEST_CONFIG)
    	if [ -n "$ACCOUNTS" ] && [ ! -r "$ACCOUNTS" ]; then
            echo "> Generating $ACCOUNTS and OpenStack resources"
            DIR=$(dirname $TEMPEST_CONFIG)
            cd $DIR && tempest account-generator \
	    	-c $TEMPEST_CONFIG \
	    	--os-username $OS_USERNAME \
	    	--os-password $OS_PASSWORD \
	    	--os-tenant-name $OS_PROJECT_NAME \
	    	--tag "test" -r 1 \
	    	"$ACCOUNTS"
    	else
            echo "> No generating test_accounts_file, file not defined!"
        fi
    else
	echo "> Cannot generate test_accounts_file, OS_* variables not defined or TEMPEST_CONFIG not defined"
    fi
fi
