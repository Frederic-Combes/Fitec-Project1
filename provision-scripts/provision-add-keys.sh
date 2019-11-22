#!/bin/sh

set -e
set -u

HOSTNAME="$(hostname)"
VAGRANT_HOME="/home/vagrant"
ROOT_HOME="/root"
SYNC_FOLDER="/provision-files"

export DEBIAN_FRONTEND=noninteractive

# Install SSH keys for Ansible
cp $SYNC_FOLDER/ansible_rsa $VAGRANT_HOME/.ssh/ansible_rsa || :
cp $SYNC_FOLDER/ansible_rsa.pub $VAGRANT_HOME/.ssh/ansible_rsa.pub || :

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

# Sets ownership and RWX rights for SSH-related files
chown -R vagrant:vagrant $VAGRANT_HOME/.ssh
chmod 0600 $VAGRANT_HOME/.ssh/*
chmod 0644 $VAGRANT_HOME/.ssh/config
chmod 0700 $VAGRANT_HOME/.ssh

echo "[SUCCESS] Add keys: $HOSTNAME."
