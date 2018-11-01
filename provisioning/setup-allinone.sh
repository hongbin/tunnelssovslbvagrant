#!/usr/bin/env bash

# Get the IP address
ipaddress=$1

# Adjust local.conf
cat << DEVSTACKEOF > /opt/stack/devstack/local.conf

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

enable_plugin zun https://git.openstack.org/openstack/zun
enable_plugin zun-tempest-plugin https://git.openstack.org/openstack/zun-tempest-plugin
enable_plugin devstack-plugin-container https://git.openstack.org/openstack/devstack-plugin-container
enable_plugin kuryr-libnetwork https://git.openstack.org/openstack/kuryr-libnetwork

KURYR_CAPABILITY_SCOPE=global
KURYR_ETCD_PORT=2379
KURYR_PROCESS_EXTERNAL_CONNECTIVITY=False

LIBS_FROM_GIT="python-zunclient"
DEVSTACKEOF

/opt/stack/devstack/stack.sh
