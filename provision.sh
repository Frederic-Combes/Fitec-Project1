#!/bin/sh

set -e
set -u

HOSTNAME="$(hostname)"
VAGRANT_HOME="/home/vagrant"
ROOT_HOME="/root"

export DEBIAN_FRONTEND=noninteractive

apt-get update

# Basic utility
apt-get install -y apt-transport-https ca-certificates gnupg2
apt-get install -y python3 software-properties-common
apt-get install -y curl wget rsync

# Aliasing IP adresses
sed -i -e '/^## BEGIN PROVISION/,/^## END PROVISION/d' /etc/hosts
cat >> /etc/hosts <<-MARK
	## BEGIN PROVISION
	192.168.50.100  s0.infra
	## END PROVISION
MARK

cat > /etc/resolv.conf <<-MARK
nameserver 192.168.50.100
MARK

# Allow the ansible SSH key
mkdir -p /root/.ssh
cat /provision-files/ansible_rsa.pub >> $ROOT_HOME/.ssh/authorized_keys || :
sort -u $ROOT_HOME/.ssh/authorized_keys > $ROOT_HOME/.ssh/authorized_keys.tmp
mv $ROOT_HOME/.ssh/authorized_keys.tmp $ROOT_HOME/.ssh/authorized_keys
rm -Rf /provision-files || :

# Fix rights for SSH related files
chmod 0600 $ROOT_HOME/.ssh/*
chmod 0700 $ROOT_HOME/.ssh

chmod 0644 $ROOT_HOME/.ssh/config || :

# DHCP stuff
echo "iface eth1 inet dhcp" > /etc/network/interfaces.d/eth1

echo "Successfully provisionned $HOSTNAME"
