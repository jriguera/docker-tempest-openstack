#!/bin/bash

# Docker with confd to manage the configuration
# see https://github.com/kelseyhightower/confd/blob/master/docs/quick-start-guide.md
IMAGE=tempest
DATADIR="$(pwd)/tempest"
mkdir -p $DATADIR

[ -r openrc.sh ] && . openrc.sh
[ -r accounts.yaml ] && mkdir -p $DATADIR/etc && cp -v accounts.yaml $DATADIR/etc/accounts.yaml
[ -r tempest.conf ] && mkdir -p $DATADIR/etc && cp -v tempest.conf $DATADIR/etc/tempest.conf
[ -r logging.conf ] && mkdir -p $DATADIR/etc && cp -v logging.conf $DATADIR/etc/logging.conf

# Run the image
# First, define the ETCD/Consul/Env keys for the configuration

# If tempest config file is defined, no autoconfiguration will be done
# To speed up the startup, you can point to the configuration created
# previously on the tempest etc folder
#-e TEMPEST_CONFIG=/etc/tempest/tempest.conf \
# If accounts is defined, no admin credentials have to be provided,
# only credentias for that account
#-e TEMPEST_AUTH_TESTACCOUNTSFILE=/etc/tempest/accounts.yml \
#-e TEMPEST_AUTH_GENERATEACCOUNTS=true \
# ... otherwise, define those variables, or ...
#-e TEMPEST_AUTH_ADMINUSERNAME=admin \
#-e TEMPEST_AUTH_ADMINTENANTNAME=admin \
#-e TEMPEST_AUTH_ADMINPASSWORD=admin \
#-e TEMPEST_AUTH_DOMAIN=Default \
# ... the values will be taken from OS_* env variables

# Identity
#-e TEMPEST_IDENTITY_URIV3
#-e TEMPEST_IDENTITY_URIV2
#-e TEMPEST_IDENTITY_REGION
#-e TEMPEST_IDENTITY_ENDPOINTTYPE
#-e TEMPEST_IDENTITY_DOMAINID

# Configuration for the rest of the services

#-e TEMPEST_HORIZON_URL \
#-e TEMPEST_GLANCE_HTTPIMAGE \
#-e TEMPEST_CINDER_BACKENDS \
#-e TEMPEST_CINDER_VENDORNAME \
#-e TEMPEST_CINDER_APIEXTENSIONS=all \
#-e TEMPEST_CINDER_STORAGEPROTOCOL=ceph \
#-e TEMPEST_NOVA_IMAGEREF \
#-e TEMPEST_NOVA_FLAVORREF \
#-e TEMPEST_NOVA_FIXEDNETNAME \
#-e TEMPEST_NOVA_EC2 \
#-e TEMPEST_NOVA_APIEXTENSIONS=all \
#-e TEMPEST_NOVA_CONSOLE=vnc \
#-e TEMPEST_NOVA_LIVEMIGRATION=false \
#-e TEMPEST_NEUTRON_FLOATINGPOOL \
#-e TEMPEST_NEUTRON_PUBLICNETID \
#-e TEMPEST_NEUTRON_APIEXTENSIONS=all \
#-e TEMPEST_NEUTRON_TENANTCIDR \
#-e TEMPEST_NEUTRON_TENANTREACHABLE=false \
#-e TEMPEST_NEUTRON_DNSSERVERS=8.8.8.8 \
#-e TEMPEST_HEAT_INSTANCETYPE \
#-e TEMPEST_HEAT_KEYPAIRNAME \
#-e TEMPEST_VALIDATION_RUN \
#-e TEMPEST_VALIDATION_CONNECT \
#-e TEMPEST_VALIDATION_SSHNET \
#-e TEMPEST_VALIDATION_FLOATINGIPRANGE \
#-e TEMPEST_VALIDATION_SSHUSER=cirros \
#-e TEMPEST_VALIDATION_SSHPASS=cubswin:) \
#-e TEMPEST_SCENARIO_IMGFILE \
#-e TEMPEST_SCENARIO_IMGREGEX \
#-e TEMPEST_SCENARIO_FLAVORREGEX \

docker run -i -t -v ${DATADIR}:/tempest \
-e OS_AUTH_URL=${OS_AUTH_URL} \
-e OS_AUTH_VERSION=${OS_AUTH_VERSION:-3} \
-e OS_REGION_NAME=${OS_REGION_NAME:-RegionOne} \
-e OS_ENDPOINT_TYPE=${OS_ENDPOINT_TYPE:-internalURL} \
-e OS_PROJECT_NAME=${OS_PROJECT_NAME:-admin} \
-e OS_PROJECT_DOMAIN_ID=${OS_PROJECT_DOMAIN_ID:-default} \
-e OS_USERNAME=${OS_USERNAME:-admin} \
-e OS_PASSWORD=${OS_PASSWORD} \
-e OS_USER_DOMAIN_ID=${OS_USER_DOMAIN_ID:-default} \
-e TEMPEST_AUTH_TEMPESTROLES="_member_,_test_" \
-e TEMPEST_NOVA_CONSOLE=spice \
-e TEMPEST_AUTH_ISOLATEDNETWORKING=true \
-e TEMPEST_DEBUG=false \
-e TEMPEST_RESOURCESPREFIX="test" \
-e TEMPEST_HORIZON_ENABLED='' \
-e TEMPEST_NEUTRON_ENABLED='' \
-e TEMPEST_GLANCE_ENABLED='' \
-e TEMPEST_NOVA_ENABLED='' \
-e TEMPEST_CINDER_ENABLED=false \
-e TEMPEST_HEAT_ENABLED=false \
-e TEMPEST_IRONIC_ENABLED=false \
-e TEMPEST_CEILOMETER_ENABLED=false \
-e TEMPEST_SWIFT_ENABLED=false \
-e TEMPEST_VALIDATION_RUN=true \
-e TEMPEST_VALIDATION_CONNECT=floating \
-e TEMPEST_VALIDATION_SSHNET=public \
-e TEMPEST_VALIDATION_FLOATINGIPRANGE=10.200.10.10/29 \
-e TEMPEST_NEUTRON_FLOATINGPOOL=public \
-e TEMPEST_NEUTRON_TENANTCIDR=10.0.0.0/24 \
-e TEMPEST_NEUTRON_TENANTREACHABLE=false \
$IMAGE "$@"
