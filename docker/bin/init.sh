#!/bin/bash

# if main tempest config file exists, do not do anything
export TEMPEST_CONFIG=${TEMPEST_CONFIG:-$TEMPEST_DIR/etc/tempest.conf}
export TEMPEST_CONFIG_DIR=$(dirname $TEMPEST_CONFIG)
export TEMPEST_COMMAND=${TEMPEST_COMMAND:-ostestr}

if [ ! -d "$TEMPEST_DIR/.testrepository" ]; then
    for initd in $(ls /etc/my_init.d/); do
	source /etc/my_init.d/$initd
    done
else
    echo "> Skipping configuration, .testrepository exists!"
fi

# Scan /tempest for ssh keys to add
[ -r "$TEMPEST_DIR/id_rsa" ] && ssh-add "$TEMPEST_DIR/id_rsa"

# Run command
cd $TEMPEST_DIR
if [ $# == 0 ]; then
    exec ostestr --list
elif [ "$TEMPEST_COMMAND" == "ostestr" ]; then
    exec ostestr "$@"
else
    exec testr "$@" | subunit-trace -n -f
fi
