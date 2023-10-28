#!/bin/bash
set -ex

# Setup microsoft packages repository for moby
# Download the repository configuration package
curl https://packages.microsoft.com/config/rhel/8/prod.repo > ./microsoft-prod.repo
# Copy the generated list to the sources.list.d directory
cp ./microsoft-prod.repo /etc/yum.repos.d/

yum repolist

# Install Kernel dependencies
KERNEL=( $(rpm -q kernel | sed 's/kernel\-//g') )
yum install -y https://dl.rockylinux.org/pub/rocky/8.8/BaseOS/x86_64/os/Packages/k/kernel-devel-${KERNEL}.rpm \
    https://dl.rockylinux.org/pub/rocky/8.8/BaseOS/x86_64/os/Packages/k/kernel-headers-${KERNEL}.rpm \
    https://dl.rockylinux.org/pub/rocky/8.8/BaseOS/x86_64/os/Packages/k/kernel-modules-extra-${KERNEL}.rpm

../common/install_utils.sh
