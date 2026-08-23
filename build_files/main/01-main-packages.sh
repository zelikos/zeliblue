#!/bin/bash

set -ouex pipefail

echo "===Enabling extra repositories==="

dnf5 -y copr enable ublue-os/packages
dnf5 -y copr enable ublue-os/staging

echo "===Installing packages==="

dnf5 -y install \
  fastfetch \
  fish \
  iwd \
  intel-lpmd

# Swap GNOME Software for Bazaar
dnf5 -y remove gnome-software
dnf5 -y install bazaar

dnf5 -y remove \
  gnome-classic-session
