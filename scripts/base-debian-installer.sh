#!/bin/bash
set -e

export DEBIAN_FRONTEND="noninteractive"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"
export LC_ALL="en_US.UTF-8"

apt-get update
apt-get -y dist-upgrade
apt-get -y install sudo git curl wget ca-certificates openssh-client gnupg2 locales tar gzip unzip procps lsof tzdata lsb-release apt-utils dialog jq yq
apt-get clean
rm -rf /var/lib/apt/lists/*

