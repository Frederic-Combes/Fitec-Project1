#!/bin/sh

set -e
set -u

HOSTNAME="$(hostname)"
VAGRANT_HOME="/home/vagrant"
ROOT_HOME="/root"
SYNC_FOLDER="/provision-files"

export DEBIAN_FRONTEND=noninteractive

cd $VAGRANT_HOME/src/ansible
ansible-playbook -i inventories/cluster.yml install-dhcp.yml
ansible-playbool -i inventories/cluster.yml install.yml

echo "Ansible play: $HOSTNAME: done."
