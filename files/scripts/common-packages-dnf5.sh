#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

dnf5 -y install \
  fastfetch \
  fish \
  glow \
  gum \
  micro \
  rsms-inter-fonts \
  rsms-inter-vf-fonts

dnf5 -y remove \
  firefox \
  firefox-langpacks
