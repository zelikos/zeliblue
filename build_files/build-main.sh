#!/bin/bash

set -ouex pipefail

echo "===Copying files==="

mkdir /tmp/just && cp /ctx/just/zeliblue.just /tmp/just/
rsync -rvK /ctx/system_files/shared/ /
rsync -rvK /ctx/system_files/gnome/ /

# Generate image-info.json
/ctx/build_files/shared/00-image-info.sh

# Install kernel & any akmods
/ctx/build_files/shared/01-install-kernel.sh

# Enable extra repositories & install packages
/ctx/build_files/main/01-main-packages.sh

# systemd services, gschemas, etc
/ctx/build_files/main/02-main-config-services.sh

# Overrides
/ctx/build_files/main/03-main-overrides.sh

# Finalize
/ctx/build_files/shared/02-finalize.sh
