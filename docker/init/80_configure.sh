#!/bin/bash

if [ ! -d "$TEMPEST_DIR/.testrepository" ]; then
    echo "> Initializing tempest repository"
    MOVED=''
    if [ -d "$TEMPEST_CONFIG_DIR" ]; then
        MOVED=$(mktemp -d)
	cp -a "$TEMPEST_CONFIG_DIR"/* $MOVED
        rm -rf "$TEMPEST_CONFIG_DIR"
    fi
    (
       	tempest init $TEMPEST_DIR
    )
    if [ -n "$MOVED" ]; then
	for f in $MOVED/*; do
	    mv "$f" "$TEMPEST_CONFIG_DIR"
        done
    fi
fi

# Run confd
if command -v confd >/dev/null 2>&1; then
    	ETCD_PORT=${ETCD_PORT:-4001}
    	ETCD_HOST=${ETCD_HOST:-10.1.42.1}

    	if alarm 3 "echo > /dev/tcp/$ETCD_HOST/$ETCD_PORT" 2> /dev/null; then
    		# Run confd in the background to watch the upstream servers
      		confd -onetime -backend etcd -node "http://$ETCD_HOST:$ETCD_PORT"
    	fi
fi
