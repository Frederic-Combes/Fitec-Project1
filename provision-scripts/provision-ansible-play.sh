#!/bin/sh

set -e
set -u

HOSTNAME="$(hostname)"
VAGRANT_HOME="/home/vagrant"
ROOT_HOME="/root"
SYNC_FOLDER="/provision-files"

export DEBIAN_FRONTEND=noninteractive

mkdir -p $VAGRANT_HOME/src
cp -R $SYNC_FOLDER/src/ $VAGRANT_HOME/ || :
chown -R vagrant:vagrant $VAGRANT_HOME/src/

cd $VAGRANT_HOME/src/ansible
su vagrant -c "ansible-playbook -i inventories/cluster.yml install-dhcp.yml"
su vagrant -c "ansible-playbook -i inventories/cluster.yml install.yml"

echo "[SUCCESS] Ansible play: $HOSTNAME."
