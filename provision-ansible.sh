#!/bin/sh

set -e
set -u

HOSTNAME="$(hostname)"
VAGRANT_HOME="/home/vagrant"
ROOT_HOME="/root"
SYNC_FOLDER="/provision-files"

export DEBIAN_FRONTEND=noninteractive

apt-get update

# Basic utility
apt-get install -y apt-transport-https ca-certificates gnupg2
apt-get install -y curl wget rsync
apt-get install -y git vim
apt-get install -y python3 software-properties-common make

# Ansible
apt-get update
apt-get install -y ansible

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
mkdir -p $ROOT_HOME/.ssh
cat $SYNC_FOLDER/ansible_rsa.pub >> $ROOT_HOME/.ssh/authorized_keys || :
sort -u $ROOT_HOME/.ssh/authorized_keys > $ROOT_HOME/.ssh/authorized_keys.tmp
mv $ROOT_HOME/.ssh/authorized_keys.tmp $ROOT_HOME/.ssh/authorized_keys

# Fix rights for SSH related files
chmod 0600 $ROOT_HOME/.ssh/*
chmod 0700 $ROOT_HOME/.ssh

chmod 0644 $ROOT_HOME/.ssh/config || :

# Install SSH keys for Ansible
cp $SYNC_FOLDER/ansible_rsa $VAGRANT_HOME/.ssh/ansible_rsa || :
cp $SYNC_FOLDER/ansible_rsa.pub $VAGRANT_HOME/.ssh/ansible_rsa.pub || :
chmod 0600 $VAGRANT_HOME/.ssh/ansible_rsa

# Install SSH key for github
cp $SYNC_FOLDER/ansible_rsa $VAGRANT_HOME/.ssh/github_rsa || :
cp $SYNC_FOLDER/ansible_rsa.pub $VAGRANT_HOME/.ssh/github_rsa.pub || :
chmod 0600 $VAGRANT_HOME/.ssh/github_rsa

# Setup SSH config File
cat > $VAGRANT_HOME/.ssh/config <<-MARK
	Host s*.infra
	    User root
	    IdentityFile ~/.ssh/ansible_rsa
	    StrictHostKeyChecking no

	Host github.com
	    StrictHostKeyChecking no
	    User git
	    IdentityFile ~/.ssh/github_rsa
MARK

# Fix rigths for SSH related files
chmod 0600 $VAGRANT_HOME/.ssh/*
chmod 0644 $VAGRANT_HOME/.ssh/config
chmod 0700 $VAGRANT_HOME/.ssh

# sed -i -e '/## BEGIN PROVISION/,/## END PROVISION/d' /home/vagrant/.bashrc

# cat >> /home/vagrant/.bashrc <<-MARK
# 	## BEGIN PROVISION
# 	eval \$(ssh-agent -s)
# 	ssh-add ~/.ssh/ansible_rsa
# 	## END PROVISION
# MARK

# Finalize SSH
chown -R vagrant:vagrant $VAGRANT_HOME/.ssh

# Setup the makefile
mkdir -p $VAGRANT_HOME/src
cp -R $SYNC_FOLDER/src/ $VAGRANT_HOME/ || :
chown -R vagrant:vagrant $VAGRANT_HOME/src/

# Finalize provisioning
rm -Rf $SYNC_FOLDER || :

echo "Successfully provisionned $HOSTNAME"
