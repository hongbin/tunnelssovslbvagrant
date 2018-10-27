#!/bin/sh

DEBIAN_FRONTEND=noninteractive sudo apt-get -qqy update

# Prepare for devstack

sudo mkdir -p /opt/stack
sudo chown vagrant:vagrant /opt
sudo chown vagrant:vagrant /opt/stack
git clone https://git.openstack.org/openstack-dev/devstack /opt/stack/devstack

# We need swap space to do any sort of scale testing with the Vagrant config.
# Without this, we quickly run out of RAM and the kernel starts whacking things.
sudo rm -f /swapfile1
sudo dd if=/dev/zero of=/swapfile1 bs=1024 count=8388608
sudo chown root:root /swapfile1
sudo chmod 0600 /swapfile1
sudo mkswap /swapfile1
sudo swapon /swapfile1
