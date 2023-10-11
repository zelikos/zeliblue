#!/usr/bin/env bash

IMAGE_INFO="/usr/share/ublue-os/image-info.json"
BASE_IMAGE_NAME=$(jq -r '."image-flavor"' < $IMAGE_INFO)

if grep -q "kinoite" <<< "${BASE_IMAGE_NAME}"; then
  SUDO_ASKPASS='/usr/bin/ksshaskpass'
elif grep -q "silverblue" <<< "${BASE_IMAGE_NAME}"; then
  SUDO_ASKPASS='/usr/libexec/openssh/gnome-ssh-askpass'
fi
export SUDO_ASKPASS