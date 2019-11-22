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
apt-get install -y python3 software-properties-common
apt-get install -y curl wget rsync

echo "Base packages: $HOSTNAME: done."
