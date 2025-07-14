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
  micro \
  ublue-brew

if [[ $ZELIBLUE_IMAGE_TAG == "testing" ]]; then
  dnf5 -y install bazaar
fi

dnf5 -y remove \
  firefox \
  firefox-langpacks \
  gnome-classic-session \
  gnome-tweaks \
  ublue-os-update-services

dnf5 -y swap \
  --repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
  fwupd fwupd
