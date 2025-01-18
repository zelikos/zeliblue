#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

dnf5 -y copr enable kylegospo/bazzite
dnf5 -y copr enable ublue-os/staging

dnf5 -y install gnome-shell-extension-hotedge
dnf5 -y remove \
  gnome-classic-session \
  gnome-tweaks
