#!/bin/bash

# Check if there are OS_AUTH env variables for autoconfiguration
if [ -z "$OS_AUTH_URL" ] || [ -z "$OS_USERNAME" ] || [ -z "$OS_PASSWORD" ] || [ -z "$OS_PROJECT_NAME" ]; then
    echo "> Env OS_* variables not defined for autoconfiguration"
    return 1
fi

# Default env variables
export OS_REGION_NAME=${OS_REGION_NAME:-RegionOne}
export OS_ENDPOINT_TYPE=${OS_ENDPOINT_TYPE:-internalURL}
export OS_USER_DOMAIN_ID=${OS_USER_DOMAIN_ID:-default}
export OS_PROJECT_DOMAIN_ID=${OS_PROJECT_DOMAIN_ID:-$OS_USER_DOMAIN_ID}
export OS_AUTH_URL=${OS_AUTH_URL%/}
if [ -z "$OS_AUTH_VERSION" ]; then
    export OS_AUTH_VERSION=3
    [ "$OS_AUTH_URL" == "${OS_AUTH_URL%v3}" ] && export OS_AUTH_VERSION=2
fi
if [ "$OS_AUTH_VERSION" == "2" ]; then
    export TEMPEST_IDENTITY_URIV2=${TEMPEST_IDENTITY_URIV2:-$OS_AUTH_URL}
    unset TEMPEST_IDENTITY_URIV3
else
    export TEMPEST_IDENTITY_URIV3=${TEMPEST_IDENTITY_URIV3:-$OS_AUTH_URL}
    unset TEMPEST_IDENTITY_URIV2
fi
echo "> Using $OS_AUTH_URL ($OS_AUTH_VERSION)"
export OS_IDENTITY_API_VERSION=${OS_AUTH_VERSION}

export TEMPEST_IDENTITY_REGION=${TEMPEST_IDENTITY_REGION:-$OS_REGION_NAME}
export TEMPEST_IDENTITY_ENDPOINTTYPE=${TEMPEST_IDENTITY_ENDPOINTTYPE:-$OS_ENDPOINT_TYPE}
export TEMPEST_IDENTITY_DOMAINID=${TEMPEST_IDENTITY_DOMAINID:-$OS_USER_DOMAIN_ID}
export TEMPEST_IDENTITY_APIEXTENSIONS=${TEMPEST_IDENTITY_APIEXTENSIONS:-all}
# Get admin credentials from env or define this file with the resources already created ...
export TEMPEST_AUTH_TESTACCOUNTSFILE=${TEMPEST_AUTH_TESTACCOUNTSFILE:-$TEMPEST_CONFIG_DIR/accounts.yaml}
export TEMPEST_AUTH_GENERATEACCOUNTS=${TEMPEST_AUTH_GENERATEACCOUNTS:-false}
if [ "$TEMPEST_AUTH_GENERATEACCOUNTS" != "true" ] && [ ! -r "$TEMPEST_AUTH_TESTACCOUNTSFILE" ]; then
    unset TEMPEST_AUTH_TESTACCOUNTSFILE
    # Define the rest of the parameters from env
    export TEMPEST_AUTH_ADMINUSERNAME=${TEMPEST_AUTH_ADMINUSERNAME:-$OS_USERNAME}
    export TEMPEST_AUTH_ADMINTENANTNAME=${TEMPEST_AUTH_ADMINTENANTNAME:-$OS_PROJECT_NAME}
    export TEMPEST_AUTH_ADMINPASSWORD=${TEMPEST_AUTH_ADMINPASSWORD:-$OS_PASSWORD}
    export OS_TENANT_NAME=${OS_PROJECT_NAME}
else
    echo "> Using $TEMPEST_AUTH_TESTACCOUNTSFILE for accounts"
    # TODO parse yaml and use its account settings for openstack client
fi
export TEMPEST_AUTH_DOMAIN=${TEMPEST_AUTH_DOMAIN:-Default}
export TEMPEST_AUTH_TEMPESTROLES=${TEMPEST_AUTH_TEMPESTROLES:-_member_}

# Other variables
export TEMPEST_DEBUG=${TEMPEST_DEBUG:-false}
export TEMPEST_RESOURCESPREFIX=${TEMPEST_RESOURCESPREFIX:-test}
export TEMPEST_HTTPIMG=${TEMPEST_HTTPIMG:-http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img}
export TEMPEST_REGEXIMG=${TEMPEST_REGEXIMG:-.*cirros.*}

# What do you want to test? Empty means "auto"
export TEMPEST_CINDER_ENABLED=${TEMPEST_CINDER_ENABLED:-}
export TEMPEST_NEUTRON_ENABLED=${TEMPEST_NEUTRON_ENABLED:-}
export TEMPEST_GLANCE_ENABLED=${TEMPEST_GLANCE_ENABLED:-}
export TEMPEST_NOVA_ENABLED=${TEMPEST_NOVA_ENABLED:-}
export TEMPEST_HEAT_ENABLED=${TEMPEST_HEAT_ENABLED:-}
export TEMPEST_HORIZON_ENABLED=${TEMPEST_HORIZON_ENABLED:-}
export TEMPEST_IRONIC_ENABLED=${TEMPEST_IRONIC_ENABLED:-}
export TEMPEST_CEILOMETER_ENABLED=${TEMPEST_CEILOMETER_ENABLED:-}
export TEMPEST_SWIFT_ENABLED=${TEMPEST_SWIFT_ENABLED:-}

# For Horizon
export TEMPEST_HORIZON_URL=${TEMPEST_HORIZON_URL:-}

# For Glance tests
export TEMPEST_GLANCE_HTTPIMAGE=${TEMPEST_GLANCE_HTTPIMAGE:-$TEMPEST_HTTPIMG}

# For Cinder
export TEMPEST_CINDER_VENDORNAME=${TEMPEST_CINDER_VENDORNAME:-}
export TEMPEST_CINDER_APIEXTENSIONS=${TEMPEST_CINDER_APIEXTENSIONS:-all}
export TEMPEST_CINDER_STORAGEPROTOCOL=${TEMPEST_CINDER_STORAGEPROTOCOL:-ceph}
export TEMPEST_CINDER_BACKENDS=${TEMPEST_CINDER_BACKENDS:-}

# For Nova
export TEMPEST_NOVA_IMAGEREF=${TEMPEST_NOVA_IMAGEREF:-}
export TEMPEST_NOVA_FLAVORREF=${TEMPEST_NOVA_FLAVORREF:-}
export TEMPEST_NOVA_FIXEDNETNAME=${TEMPEST_NOVA_FIXEDNETNAME:-}
export TEMPEST_NOVA_EC2=${TEMPEST_NOVA_EC2:-}
export TEMPEST_NOVA_APIEXTENSIONS=${TEMPEST_NOVA_APIEXTENSIONS:-all}
export TEMPEST_NOVA_CONSOLE=${TEMPEST_NOVA_CONSOLE:-vnc}
export TEMPEST_NOVA_LIVEMIGRATION=${TEMPEST_NOVA_LIVEMIGRATION:-false}

# For Neutron
export TEMPEST_NEUTRON_FLOATINGPOOL=${TEMPEST_NEUTRON_FLOATINGPOOL:-}
export TEMPEST_NEUTRON_PUBLICNETID=${TEMPEST_NEUTRON_PUBLICNETID:-}
export TEMPEST_NEUTRON_APIEXTENSIONS=${TEMPEST_NEUTRON_APIEXTENSIONS:-all}
export TEMPEST_NEUTRON_TENANTCIDR=${TEMPEST_NEUTRON_TENANTCIDR:-10.100.0.0/16}
export TEMPEST_NEUTRON_TENANTREACHABLE=${TEMPEST_NEUTRON_TENANTREACHABLE:-}
export TEMPEST_NEUTRON_DNSSERVERS=${TEMPEST_NEUTRON_DNSSERVERS:-8.8.8.8}

# For Heat
export TEMPEST_HEAT_INSTANCETYPE=${TEMPEST_HEAT_INSTANCETYPE:-}
export TEMPEST_HEAT_KEYPAIRNAME=${TEMPEST_HEAT_KEYPAIRNAME:-}

# Validation
export TEMPEST_VALIDATION_RUN=${TEMPEST_VALIDATION_RUN:-}
export TEMPEST_VALIDATION_CONNECT=${TEMPEST_VALIDATION_CONNECT:-}
export TEMPEST_VALIDATION_SSHNET=${TEMPEST_VALIDATION_SSHNET:-}
export TEMPEST_VALIDATION_FLOATINGIPRANGE=${TEMPEST_VALIDATION_FLOATINGIPRANGE:-}
export TEMPEST_VALIDATION_SSHUSER=${TEMPEST_VALIDATION_SSHUSER:-cirros}
export TEMPEST_VALIDATION_SSHPASS=${TEMPEST_VALIDATION_SSHPASS:-cubswin:)}

# Scenarios
export TEMPEST_SCENARIO_IMGFILE=${TEMPEST_SCENARIO_IMGFILE:-}
export TEMPEST_SCENARIO_IMGREGEX=${TEMPEST_SCENARIO_IMGREGEX:-$TEMPEST_REGEXIMG}
export TEMPEST_SCENARIO_FLAVORREGEX=${TEMPEST_SCENARIO_FLAVORREGEX:-}


################################################################################

# Timeout function
alarm() {
    local timeout=$1; shift;
    bash -c "$@" &
    local pid=$!
    {
      sleep $timeout
      kill $pid 2> /dev/null
    } &
    wait $pid 2> /dev/null
    return $?
}

# Identity service checker
check_service() {
    local uuid=$(openstack service list -f value | awk -v service=$1 '{ if ($2 == service) print $1 }')
    if [ -z "$uuid" ]; then
        echo "false"
        return 1
    fi
    echo "true"
    return 0
}

# Horizon
if [ -z "$TEMPEST_HORIZON_ENABLED" ]; then
    if [ -z "$TEMPEST_HORIZON_URL" ]; then
        # Trying to find the Horizon URL
        HORIZON=$(openstack endpoint list -f value | awk '/keystone identity .* public/{ split($7,u,":"); print u[1]":"u[2] }')
        HORIZON="$HORIZON"
    else
        HORIZON=$TEMPEST_HORIZON_URL
    fi
    if curl -fsS "$HORIZON" >/dev/null; then
        export TEMPEST_HORIZON_ENABLED="true"
        # Assuming Horizon is on the same IP as keystone ...
        export TEMPEST_HORIZON_URL=$HORIZON
        echo "> Horizon tempest url: $HORIZON"
    else
        export TEMPEST_HORIZON_ENABLED="false"
        unset TEMPEST_HORIZON_URL
        echo "> Disabling Horizon tempest because '$HORIZON' not reachable"
    fi
fi

# Glance
if [ -z "$TEMPEST_GLANCE_ENABLED" ]; then
    export TEMPEST_GLANCE_ENABLED=$(check_service "glance")
    if [ "$TEMPEST_GLANCE_ENABLED" == "true" ]; then
        GLANCE_IMG=$(openstack image list -f value | grep -ie "$TEMPEST_REGEXIMG")
        if [ -n "$GLANCE_IMG" ]; then
            GLANCE_IMGID=$(echo $GLANCE_IMG | cut -d' ' -f 1)
            GLANCE_IMGNAME=$(echo $GLANCE_IMG | cut -d' ' -f 2)
            echo "> Glance tempest enabled with image '$GLANCE_IMGNAME'"
        else
            export TEMPEST_GLANCE_ENABLED="false"
            echo "> Disabling Glance tempest because image with regex '$TEMPEST_REGEXIMG' not found"
        fi
    fi
fi

# Neutron
if [ -z "$TEMPEST_NEUTRON_ENABLED" ]; then
    export TEMPEST_NEUTRON_ENABLED=$(check_service "neutron")
    if [ "$TEMPEST_NEUTRON_ENABLED" == "true" ]; then
        if [ -z "$TEMPEST_NEUTRON_FLOATINGPOOL" ]; then
                NEUTRON_PUBLICNET=$(neutron net-list --router:external=true -f value | head -n 1)
        else
                NEUTRON_PUBLICNET=$(neutron net-list --router:external=true -f value | grep -i "$TEMPEST_NEUTRON_FLOATINGPOOL")
        fi
        NEUTRON_PUBLICNETNAME=$(echo $NEUTRON_PUBLICNET | cut -d' ' -f 2)
        NEUTRON_PUBLICNETID=$(echo $NEUTRON_PUBLICNET | cut -d' ' -f 1)
        export TEMPEST_NEUTRON_FLOATINGPOOL=${TEMPEST_NEUTRON_FLOATINGPOOL:-$NEUTRON_PUBLICNETNAME}
        export TEMPEST_NEUTRON_PUBLICNETID=${TEMPEST_NEUTRON_PUBLICNETID:-$NEUTRON_PUBLICNETID}
        echo "> Using neutron '$NEUTRON_PUBLICNETNAME' ($TEMPEST_NEUTRON_PUBLICNETID) as floating IP pool"
    fi
fi

# Cinder
if [ -z "$TEMPEST_CINDER_ENABLED" ]; then
    export TEMPEST_CINDER_ENABLED=$(check_service "cinder")
    if [ "$TEMPEST_CINDER_ENABLED" == "true" ]; then
        [ -z "$TEMPEST_CINDER_VENDORNAME" ] && unset TEMPEST_CINDER_VENDORNAME
        [ -z "$TEMPEST_CINDER_BACKENDS" ] && unset TEMPEST_CINDER_BACKENDS
        echo "> Enabling Cinder tempest"
    fi
fi

# Nova
if [ -z "$TEMPEST_NOVA_ENABLED" ]; then
    export TEMPEST_NOVA_ENABLED=$(check_service "nova")
    if [ "$TEMPEST_NOVA_ENABLED" == "true" ]; then
        export TEMPEST_NOVA_IMAGEREF=${TEMPEST_NOVA_IMAGEREF:-$GLANCE_IMGID}
        if [ -z "$TEMPEST_NOVA_FLAVORREF" ]; then
            FLAVOR=$(openstack flavor list -f value | awk '{ if ($3 >= 1024) print $0 }' | sort -n -k 3 | head -n 1)
            export TEMPEST_NOVA_FLAVORREF=$(echo $FLAVOR | cut -d' ' -f 1)
        fi
        if [ -z "$TEMPEST_NOVA_IMAGEREF" ] || [ -z "$TEMPEST_NOVA_FLAVORREF" ]; then
            export TEMPEST_NOVA_ENABLED="false"
            echo "> Disabling Nova tempest because IMAGE_ID or FLAVOR_ID unknown"
        else
            echo "> Enabling Nova tempest using flavor '$TEMPEST_NOVA_FLAVORREF'"
       	fi
    fi
fi
if [ "$TEMPEST_NOVA_ENABLED" == "true" ] && [ -z "$TEMPEST_NOVA_EC2" ]; then
    EC2=$(check_service "ec2")
    if [ -n "$EC2" ]; then
	export TEMPEST_NOVA_EC2=$EC2
        echo "> Enabling Nova tempest for EC2"
    fi
fi

# Nova and Neutron networking and Validation
if [ "$TEMPEST_NEUTRON_ENABLED" == "true" ] && [ "$TEMPEST_NOVA_ENABLED" == "true" ]; then
    if [ -z "$TEMPEST_NEUTRON_PUBLICNETNAME" ]; then
        if [ -z "$TEMPEST_NOVA_FIXEDNETNAME" ]; then
            FIXEDNETNAME=$(openstack network list -f value | head -n 1 | cut -d' ' -f 2)
            if [ -n "$FIXEDNETNAME" ]; then
                export TEMPEST_NOVA_FIXEDNETNAME=$FIXEDNETNAME
                export TEMPEST_VALIDATION_SSHNET=${TEMPEST_VALIDATION_SSHNET:-$FIXEDNETNAME}
            fi
        fi
        export TEMPEST_NEUTRON_TENANTREACHABLE=${TEMPEST_NEUTRON_TENANTREACHABLE:-true}
        export TEMPEST_VALIDATION_CONNECT=${TEMPEST_VALIDATION_CONNECT:-fixed}
    else
        NEUTRON_PUBLICROUTER=$(neutron router-list --external_gateway_info:network_id=${NEUTRON_PUBLICNETID} -f value | head -n 1 | cut -d' ' -f 1)
        if [ -z "$NEUTRON_PUBLICROUTER" ]; then
            # Tenants wihout internal nets attached directly to external nets
            if [ -z "$TEMPEST_NOVA_FIXEDNETNAME" ]; then
                FIXEDNETNAME=$(neutron net-list --router:external=true -f value | head -n 1 | cut -d' ' -f 2)
                [ -n "$FIXEDNETNAME" ]  && export TEMPEST_NOVA_FIXEDNETNAME=$FIXEDNETNAME
            fi
            export TEMPEST_VALIDATION_SSHNET=${TEMPEST_VALIDATION_SSHNET:-$TEMPEST_NOVA_FIXEDNETNAME}
            export TEMPEST_NEUTRON_TENANTREACHABLE=${TEMPEST_NEUTRON_TENANTREACHABLE:-true}
            export TEMPEST_VALIDATION_CONNECT=${TEMPEST_VALIDATION_CONNECT:-fixed}
        else
            # Tenants with internal nets and external nets for floating ips
            if [ -z "$TEMPEST_NOVA_FIXEDNETNAME" ]; then
                FIXEDNETNAME=$(neutron net-list --router:external=false -f value | head -n 1 | cut -d' ' -f 2)
                [ -n "$FIXEDNETNAME" ]  && export TEMPEST_NOVA_FIXEDNETNAME=$FIXEDNETNAME
            fi
            export TEMPEST_VALIDATION_SSHNET=${TEMPEST_VALIDATION_SSHNET:-$TEMPEST_NEUTRON_PUBLICNETNAME}
            export TEMPEST_NEUTRON_TENANTREACHABLE=${TEMPEST_NEUTRON_TENANTREACHABLE:-false}
            export TEMPEST_VALIDATION_CONNECT=${TEMPEST_VALIDATION_CONNECT:-floating}
        fi
    fi
    export TEMPEST_VALIDATION_RUN=${TEMPEST_VALIDATION_RUN:-true}
else
    export TEMPEST_NEUTRON_TENANTREACHABLE=${TEMPEST_NEUTRON_TENANTREACHABLE:-false}
    export TEMPEST_AUTH_ISOLATEDNETWORKING=${TEMPEST_AUTH_ISOLATEDNETWORKING:-false}
    export TEMPEST_VALIDATION_RUN=${TEMPEST_VALIDATION_RUN:-false}
    export TEMPEST_VALIDATION_CONNECT=fixed
fi

# Heat
if [ -z "$TEMPEST_HEAT_ENABLED" ]; then
    export TEMPEST_HEAT_ENABLED=$(check_service "heat")
    if [ "$TEMPEST_HEAT_ENABLED" == "true" ]; then
        if [ -z "$TEMPEST_HEAT_INSTANCETYPE" ]; then
            if [ -z "$FLAVOR" ]; then
                FLAVOR=$(openstack flavor list -f value | awk '{ if ($3 >= 1024) print $0 }' | sort -n -k 3 | head -n 1)
            fi
            [ -n "$FLAVOR" ] && export TEMPEST_HEAT_INSTANCETYPE=$(echo $FLAVOR | cut -d' ' -f 2)
        fi
        if [ -z "$TEMPEST_HEAT_KEYPAIRNAME" ]; then
            if [ -z "$KEYPAIR" ]; then
                KEYPAIR=$(openstack keypair list -f value -c Name | head -n 1)
            fi
            [ -n "$KEYPAIR" ] && export TEMPEST_HEAT_KEYPAIRNAME=$KEYPAIR
        fi
        if [ -z "$TEMPEST_HEAT_KEYPAIRNAME" ] || [ -z "$TEMPEST_HEAT_INSTANCETYPE" ]; then
            export TEMPEST_HEAT_ENABLED="false"
            echo "> Disabling Heat tempest because KEYPAIR or INSTANCE_TYPE unknown"
        else
            echo "> Enabling Heat tempest with '$TEMPEST_HEAT_INSTANCETYPE'"
        fi
    fi
fi

# Ceilometer
if [ -z "$TEMPEST_CEILOMETER_ENABLED" ]; then
    export TEMPEST_CEILOMETER_ENABLED=$(check_service "ceilometer")
    if [ "$TEMPEST_CEILOMETER_ENABLED" == "true" ]; then
        echo "> Enabling Ceilometer tempest"
    fi
fi

# Scenarios
IMGFILE=$(basename $TEMPEST_HTTPIMG)
export TEMPEST_SCENARIO_IMGFILE=$TEMPEST_DIR/${TEMPEST_SCENARIO_IMGFILE:-$IMGFILE}
if [ ! -r "${TEMPEST_SCENARIO_IMGFILE}" ]; then
    echo "> Downloading cirros image for scenario tests ..."
    if ! curl -q -s -o "$TEMPEST_SCENARIO_IMGFILE" "$TEMPEST_HTTPIMG"; then
        echo "> Error downloading image for scenario tests"
    fi
fi
echo "> Using image '${TEMPEST_SCENARIO_IMGFILE}' for scenario tests"
if [ -z "$TEMPEST_SCENARIO_FLAVORREGEX" ]; then
    [ -z "$FLAVOR" ] && FLAVOR=$(openstack flavor list -f value | awk '{ if ($3 >= 1024) print $0 }' | sort -n -k 3 | head -n 1)
    [ -n "$FLAVOR" ] && export TEMPEST_SCENARIO_FLAVORREGEX=$(echo $FLAVOR | cut -d' ' -f 2)
    echo "> Using flavor '$TEMPEST_SCENARIO_FLAVORREGEX' for scenario tests"
fi

# Run confd with env
confd -onetime -backend env 2>/dev/null && echo "> Configuration generated ..."
