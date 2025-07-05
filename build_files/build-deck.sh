#!/bin/bash

set -ouex pipefail

echo "===Copying files==="

mkdir /tmp/just && cp /ctx/just/zelideck.just /tmp/just/
rsync -rvK /ctx/system_files/deck/ /

# Generate image-info.json
/ctx/build_files/shared/00-image-info.sh

# Install kernel & any akmods
# /ctx/build_files/shared/01-install-kernel.sh

# Enable extra repositories & install packages
/ctx/build_files/deck/01-deck-packages.sh

# Steam Deck firmware & Steam Game Mode setup
/ctx/build_files/deck/02-steamos-setup.sh

# systemd services, gschemas, etc
/ctx/build_files/deck/03-deck-config-services.sh

# Finalize
/ctx/build_files/shared/02-finalize.sh
