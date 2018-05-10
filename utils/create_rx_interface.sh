#!/usr/bin/env bash

BRIDGE=br-int
IFACE_ID=5f33668a-28ba-4394-a7f4-2678c2b33903
IFACE_IPV4=10.0.0.6
IFACE_IPV6=fd5c:fb43:92c3:0:f816:3eff:fe78:cfd
IFACE_MAC=fa:16:3e:78:0c:fd
IFACE_NAME=rx-miguel

# Set up the bridge
#sudo ovs-vsctl add-br $BRIDGE -- set Bridge $BRIDGE datapath_type=system protocols="OpenFlow10","OpenFlow13" fail_mode=secure
#sudo ovs-ofctl add-flow $BRIDGE actions=normal

# Set up interface
TAPNAME=tap${IFACE_ID::11}
sudo ip netns add ns-$IFACE_NAME
sudo ip netns exec ns-$IFACE_NAME ip link set lo up
sudo ip netns exec ns-$IFACE_NAME sysctl -w net.ipv6.conf.default.accept_ra=0
IFS=':'
a=($IFACE_MAC)
sudo ovs-vsctl add-port $BRIDGE $TAPNAME -- set Interface $TAPNAME type=internal external_ids='iface-id'=$IFACE_ID,'iface-status'='active','attached-mac'=${a[0]}'\:'${a[1]}'\:'${a[2]}'\:'${a[3]}'\:'${a[4]}'\:'${a[5]}
sudo ip link set $TAPNAME address ${a[0]}':'${a[1]}':'${a[2]}':'${a[3]}':'${a[4]}':'${a[5]}
sudo ip link set $TAPNAME netns ns-$IFACE_NAME
sudo ip netns exec ns-$IFACE_NAME ip link set $TAPNAME mtu 1450
sudo ip netns exec ns-$IFACE_NAME ip link set $TAPNAME up
IFS='.'
a=($IFACE_IPV4)
sudo ip netns exec ns-$IFACE_NAME ip addr add ${a[0]}.${a[1]}.${a[2]}.${a[3]}/24 broadcast ${a[0]}.${a[1]}.${a[2]}.255 dev $TAPNAME
sudo ip netns exec ns-$IFACE_NAME ip addr add $IFACE_IPV6/64  dev $TAPNAME
sudo ip netns exec ns-$IFACE_NAME ip -4 route replace default via ${a[0]}.${a[1]}.${a[2]}.1 dev $TAPNAME
IFS=':'
a=($IFACE_IPV6)
sudo ip netns exec ns-$IFACE_NAME ip -6 route replace default via ${a[0]}:${a[1]}:${a[2]}::1 dev $TAPNAME
#sudo ovs-vsctl set Port tap-tx-miguel tag=1
