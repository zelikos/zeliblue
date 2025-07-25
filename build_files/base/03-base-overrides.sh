#!/bin/bash

set -ouex pipefail


echo "===Applying overrides==="

# use override to replace mesa and others with less crippled versions
OVERRIDES=(
    "libva"
    "intel-gmmlib"
    "intel-vpl-gpu-rt"
    "intel-mediasdk"
    "libva-intel-media-driver"
    "mesa-dri-drivers"
    "mesa-filesystem"
    "mesa-libEGL"
    "mesa-libGL"
    "mesa-libgbm"
    "mesa-va-drivers"
    "mesa-vulkan-drivers"
)

dnf5 distro-sync -y --repo='fedora-multimedia' "${OVERRIDES[@]}"

# Swap to sudo-rs
if [[ $ZELIBLUE_IMAGE_TAG == "testing" ]]; then
  dnf5 -y install sudo-rs
  ln -sf /usr/bin/su-rs /usr/bin/su
  ln -sf /usr/bin/sudo-rs /usr/bin/sudo
  ln -sf /usr/bin/visudo-rs /usr/bin/visudo
fi

# Replace podman provided policy.json with ublue-os one.
mv /usr/etc/containers/policy.json /etc/containers/policy.json
