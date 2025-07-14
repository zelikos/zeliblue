#!/bin/bash

set -ouex pipefail

mkdir -p /var/roothome

echo "===Copying files==="

rsync -rvK /ctx/system_files/base/ /

# Enable extra repositories & install packages
/ctx/build_files/base/01-base-packages.sh

# systemd services, gschemas, etc
# /ctx/build_files/main/02-config-services.sh

# Overrides
/ctx/build_files/base/03-base-overrides.sh

# # Finalize
# /ctx/build_files/shared/02-finalize.sh
