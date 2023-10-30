#!/bin/bash
set -ex

# Install Python 3.8
yum install -y python3.8
ln -fs /usr/bin/python3.8 /usr/bin/python3

# Install wget
yum install -y wget

# install pssh
PSSH_VER=2.3.1-29
wget https://dl.fedoraproject.org/pub/epel/8/Everything/aarch64/Packages/p/pssh-$PSSH_VER.el8.noarch.rpm
yum install -y  pssh-$PSSH_VER.el8.noarch.rpm
rm -f pssh-$PSSH_VER.el8.noarch.rpm

# Install pre-reqs and development tools
yum groupinstall -y "Development Tools"
yum install -y numactl \
    numactl-devel \
    libxml2-devel \
    byacc \
    environment-modules \
    python3-devel \
    python3-setuptools \
    gtk2 \
    atk \
    cairo \
    tcl \
    tk \
    m4 \
    glibc-devel \
    libudev-devel \
    binutils \
    binutils-devel \
    selinux-policy-devel \
    nfs-utils \
    fuse-libs \
    libpciaccess \
    cmake \
    libnl3-devel \
    libsecret \
    rpm-build \
    make \
    check \
    check-devel \
    lsof \
    kernel-rpm-macros \
    tcsh \
    gcc-gfortran \
    perl \
    pciutils

## Disable kernel updates
echo "exclude=kernel*" | tee -a /etc/dnf/dnf.conf

# Disable dependencies on kernel core
sed -i "$ s/$/ shim*/" /etc/dnf/dnf.conf
sed -i "$ s/$/ grub2*/" /etc/dnf/dnf.conf

## Install dkms from the EPEL repository
wget -r --no-parent -A "dkms-*.el8.noarch.rpm" https://dl.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/d/
yum localinstall ./dl.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/d/dkms-*.el8.noarch.rpm -y

## Install subunit and subunit-devel from EPEL repository
wget -r --no-parent -A "subunit-*.el8.x86_64.rpm" https://dl.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/s/
yum localinstall ./dl.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/s/subunit-[0-9].*.el8.x86_64.rpm -y
yum localinstall ./dl.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/s/subunit-devel-[0-9].*.el8.x86_64.rpm -y

# Download jq utility
yum install -y jq

# Remove rpm files
rm -rf ./dl.fedoraproject.org/

# Install azcopy tool 
# To copy blobs or files to or from a storage account.
VERSION="10.17.0"
RELEASE_TAG="release20230123"
TARBALL="azcopy_linux_amd64_${VERSION}.tar.gz"
AZCOPY_DOWNLOAD_URL="https://azcopyvnext.azureedge.net/${RELEASE_TAG}/${TARBALL}"
AZCOPY_FOLDER=$(basename ${AZCOPY_DOWNLOAD_URL} .tgz)
wget ${AZCOPY_DOWNLOAD_URL}
tar -xvf ${TARBALL}

# copy the azcopy to the bin path
pushd azcopy_linux_amd64_${VERSION}
cp azcopy /usr/bin/
popd

# Allow execute permissions
chmod +x /usr/bin/azcopy

# remove tarball from azcopy
rm -rf *.tar.gz

# copy kvp client file
$COMMON_DIR/copy_kvp_client.sh
