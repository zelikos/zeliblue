#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

echo "Installing and enabling flatpaks module"
cp -r "$CONFIG_DIRECTORY/modules/usr/bin/{system,user}-flatpak-setup" "/usr/bin/{system,user}-flatpak-setup"
cp -r "$CONFIG_DIRECTORY/modules/usr/lib/systemd/system/system-flatpak-setup.service" "/usr/lib/systemd/system/system-flatpak-setup.service"
cp -r "$CONFIG_DIRECTORY/modules/usr/lib/systemd/user/user-flatpak-setup.service" "/usr/lib/systemd/user/user-flatpak-setup.service"

systemctl enable system-flatpak-setup.service
systemctl enable --global user-flatpak-setup.service

