#!/bin/sh

set -e
set -u

HOSTNAME="$(hostname)"
VAGRANT_HOME="/home/vagrant"
ROOT_HOME="/root"
SYNC_FOLDER="/provision-files"

export DEBIAN_FRONTEND=noninteractive

if [ $HOSTNAME = "s0.infra" ]
then
	cat > /etc/resolv.conf <<-MARK
	nameserver 1.1.1.1
	MARK
else
	cat > /etc/resolv.conf <<-MARK
	nameserver 192.168.50.100
	MARK
end

echo "iface eth1 inet dhcp" > /etc/network/interfaces.d/eth1
dhclient -r eth1

echo "DHCP: $HOSTNAME: done."
