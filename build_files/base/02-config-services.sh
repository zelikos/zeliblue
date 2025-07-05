#!/bin/bash

set -ouex pipefail


echo "===Compiling gschemas==="

mkdir -p /tmp/zeliblue-schema-test
find /usr/share/glib-2.0/schemas/ -type f ! -name "*.gschema.override" -exec cp {} /tmp/zeliblue-schema-test/ \;
cp /usr/share/glib-2.0/schemas/zz0-zeliblue.gschema.override /tmp/zeliblue-schema-test/

echo "Running error test for zeliblue gschema override. Aborting if failed."
glib-compile-schemas --strict /tmp/zeliblue-schema-test
echo "Compiling gschema to include zeliblue setting overrides"
glib-compile-schemas /usr/share/glib-2.0/schemas &>/dev/null


echo "===Configuring systemd services==="

systemctl enable dconf-update.service
systemctl enable brew-upgrade.timer
systemctl enable brew-update.timer
systemctl enable bootc-automatic-updates.timer
systemctl mask rpm-ostreed-automatic.timer
systemctl disable flatpak-add-fedora-repos.service

#Add the Flathub Flatpak remote
flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
