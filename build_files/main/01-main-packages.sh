#!/bin/bash

set -ouex pipefail

echo "===Enabling extra repositories==="

dnf5 -y copr enable ublue-os/packages
dnf5 -y copr enable ublue-os/staging
dnf5 -y copr enable bazzite-org/bazzite

echo "===Installing packages==="

dnf5 -y install \
  fastfetch \
  fish \
  gnome-shell-extension-hotedge \
  glow \
  gum \
  iwd \
  intel-lpmd \
  micro \
  ublue-brew

if [[ $ZELIBLUE_IMAGE_TAG == "testing" ]]; then
  dnf5 -y remove gnome-software
  dnf5 -y install bazaar
fi

dnf5 -y remove \
  gnome-classic-session
