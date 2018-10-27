#!/usr/bin/env bash

cp /vagrant/provisioning/local.conf.base /opt/stack/devstack/local.conf

# Get the IP address
ipaddress=$1

# Adjust local.conf
cat << DEVSTACKEOF >> /opt/stack/devstack/local.conf

[[local|localrc]]
# Set this host's IP
HOST_IP=$ipaddress
MULTI_HOST=1
LOGFILE=/opt/stack/logs/stack.sh.log
# Enable Neutron as the networking service
ADMIN_PASSWORD=password
DATABASE_PASSWORD=password
RABBIT_PASSWORD=password
SERVICE_PASSWORD=password
SERVICE_TOKEN=password
DEVSTACKEOF

/opt/stack/devstack/stack.sh
