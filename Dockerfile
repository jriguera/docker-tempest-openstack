# openstack-tempest
#
# VERSION  0.1.0
#
# Use phusion/baseimage as base image.
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
#
FROM phusion/baseimage:0.9.18
MAINTAINER Jose Riguera <jriguera@gmail.com>

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Delete ssh_gen_keys
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Update
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"
 
# Install Python and Basic Python Tools
RUN apt-get install -y python-minimal python-setuptools python-pip python-dev libffi-dev libssl-dev git 

# Install openstack client
RUN pip install python-openstackclient python-neutronclient python-novaclient

# Env variables for openstackclient
env LC_ALL=C
env OS_NO_CACHE=1
# We only support keystone v3
env OS_IDENTITY_API_VERSION=3
env OS_AUTH_VERSION=3
# COMMON CINDER ENVS
env CINDER_ENDPOINT_TYPE=internalURL
# COMMON NOVA ENVS
env NOVA_ENDPOINT_TYPE=internalURL
# COMMON OPENSTACK ENVS
env OS_ENDPOINT_TYPE=internalURL

# Tempest
env TEMPEST_DIR=/tempest

# Install tempest from source
RUN cd /tmp  && git clone https://github.com/openstack/tempest && pip install tempest/ && mkdir /tempest

# Install default configuration examples
ADD docker/conf/* /etc/tempest/

# prepare to run
ADD docker/bin/ /usr/bin/
ADD docker/confd/ /etc/confd/
ADD docker/init/ /etc/my_init.d/

# tempest repository
VOLUME ["/tempest"]
ENTRYPOINT [ "/usr/bin/init.sh" ]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
