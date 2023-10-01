#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

echo "Enabling flatpaks module"
systemctl enable system-flatpak-setup.service
systemctl enable --global user-flatpak-setup.service
