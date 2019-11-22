#!/bin/sh

set -e
set -u

HOSTNAME="$(hostname)"
VAGRANT_HOME="/home/vagrant"
ROOT_HOME="/root"
SYNC_FOLDER="/provision-files"

export DEBIAN_FRONTEND=noninteractive

# Aliasing IP adresses
sed -i -e '/^## BEGIN PROVISION/,/^## END PROVISION/d' /etc/hosts
cat >> /etc/hosts <<-MARK
	## BEGIN PROVISION
	192.168.50.100  s0.infra
	## END PROVISION
MARK

echo "[SUCCESS] Hosts: $HOSTNAME: done."
