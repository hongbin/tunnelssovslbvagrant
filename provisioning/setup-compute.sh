#!/usr/bin/env bash

# Script Arguments:
# $1 -  Allinone node IP adddress
ALLINONE_IP=$1

# Get the IP address
ipaddress=$2

# Adjust some things in local.conf
cat << DEVSTACKEOF >> /opt/stack/devstack/local.conf

[[local|localrc]]
# Set this host's IP
HOST_IP=$ipaddress
LOGFILE=/opt/stack/logs/stack.sh.log

# Enable services to be executed in compute node
ENABLED_SERVICES=n-cpu,q-agt,n-api-meta,placement-client,zun-compute,kuryr-libnetwork

DATABASE_PASSWORD=password
RABBIT_PASSWORD=password
SERVICE_TOKEN=password
SERVICE_PASSWORD=password
ADMIN_PASSWORD=password
DATABASE_TYPE=mysql

MULTI_HOST=1
SERVICE_HOST=$ALLINONE_IP
MYSQL_HOST=$ALLINONE_IP
RABBIT_HOST=$ALLINONE_IP
GLANCE_HOSTPORT=$ALLINONE_IP:9292
NOVA_VNC_ENABLED=True
NOVNCPROXY_URL="http://$ALLINONE_IP:6080/vnc_auto.html"
VNCSERVER_LISTEN=$ipaddress
VNCSERVER_PROXYCLIENT_ADDRESS=$ipaddress

enable_plugin devstack-plugin-container https://git.openstack.org/openstack/devstack-plugin-container
enable_plugin zun https://git.openstack.org/openstack/zun
enable_plugin kuryr-libnetwork https://git.openstack.org/openstack/kuryr-libnetwork

KURYR_CAPABILITY_SCOPE=global
KURYR_PROCESS_EXTERNAL_CONNECTIVITY=False

DEVSTACKEOF

/opt/stack/devstack/stack.sh
