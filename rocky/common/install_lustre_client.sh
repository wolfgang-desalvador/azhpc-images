#!/bin/bash
set -ex

LUSTRE_VERSION=2.15.1_24_gbaa21ca

# Expected params:
# $1 = the major version of the distro. "8" for RHEL/Rocky8, "9" for RHEL/Rocky9.

source $ROCKY_COMMON_DIR/setup_lustre_repo.sh "$1"

dnf install -y --disableexcludes=main --refresh amlfs-lustre-client-${LUSTRE_VERSION}-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
sed -i "$ s/$/ amlfs*/" /etc/dnf/dnf.conf

$COMMON_DIR/write_component_version.sh "LUSTRE" ${LUSTRE_VERSION}
