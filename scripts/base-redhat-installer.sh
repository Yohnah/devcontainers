#!/bin/bash
set -e

export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"
export LC_ALL="en_US.UTF-8"
echo "max_parallel_downloads=1" >> /etc/dnf/dnf.conf
dnf -y install epel-release
#dnf -y upgrade

dnf -y install bash
dnf -y install sudo
dnf -y install git
dnf --allowerasing -y install curl
dnf -y install wget
dnf -y install ca-certificates
dnf -y install openssh-clients
dnf -y install gnupg2
dnf -y install tar
dnf -y install gzip
dnf -y install unzip
dnf -y install procps-ng
dnf -y install lsof
dnf -y install tzdata
dnf -y install shadow-utils
dnf -y install jq
dnf -y install glibc-langpack-en
rm -rf /var/cache/dnf

