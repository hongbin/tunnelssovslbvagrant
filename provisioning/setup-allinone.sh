#!/usr/bin/env bash

cp /vagrant/provisioning/local.conf.base /opt/stack/devstack/local.conf

# Get the IP address
ipaddress=$1

# Adjust local.conf
cat << DEVSTACKEOF >> /opt/stack/devstack/local.conf

# Set this host's IP
HOST_IP=$ipaddress

# Enable Neutron as the networking service
disable_service n-net
enable_service placement-api
enable_service neutron
enable_service neutron-api
#enable_service q-svc
enable_service q-meta
enable_service q-agt
enable_service q-dhcp
enable_service q-l3
enable_service tempest

[[post-config|\$NEUTRON_CONF]]
[DEFAULT]
service_plugins=router,segments
allow_overlapping_ips=True

[[post-config|/\$Q_PLUGIN_CONF_FILE]]
[ml2]
type_drivers=flat,vxlan
tenant_network_types=vxlan
mechanism_drivers=openvswitch,linuxbridge,l2population
extension_drivers=port_security

[ml2_type_vxlan]
vni_ranges=1000:1999

[ovs]
local_ip=$ipaddress

[vxlan]
enable_vxlan=True
l2_population=True
local_ip=$ipaddress


[agent]
tunnel_types=vxlan
l2_population=True

[[post-config|\$Q_L3_CONF_FILE]]
[DEFAULT]
router_delete_namespaces=True

[[post-config|\$Q_DHCP_CONF_FILE]]
[DEFAULT]
dhcp_delete_namespaces=True
enable_isolated_metadata=True

[[post-config|\$KEYSTONE_CONF]]
[token]
expiration=30000000
DEVSTACKEOF

/opt/stack/devstack/stack.sh
