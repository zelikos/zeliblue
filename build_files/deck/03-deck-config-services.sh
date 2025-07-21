#!/bin/bash

set -ouex pipefail


echo "===Compiling gschemas==="

mkdir -p /tmp/zeliblue-schema-test
find /usr/share/glib-2.0/schemas/ -type f ! -name "*.gschema.override" -exec cp {} /tmp/zeliblue-schema-test/ \;
cp /usr/share/glib-2.0/schemas/zz1-zeliblue-deck.gschema.override /tmp/zeliblue-schema-test/

echo "Running error test for zeliblue gschema override. Aborting if failed."
glib-compile-schemas /tmp/zeliblue-schema-test
echo "Compiling gschema to include zeliblue setting overrides"
glib-compile-schemas /usr/share/glib-2.0/schemas &>/dev/null


echo "===Configuring systemd services==="

systemctl enable ds-inhibit.service
systemctl enable zelideck-autologin.service
systemctl enable zelideck-hardware-setup.service
systemctl enable wireplumber-workaround.service
systemctl enable wireplumber-sysconf.service
systemctl enable pipewire-workaround.service
systemctl enable pipewire-sysconf.service
systemctl enable scx_loader.service

systemctl disable gdm.service && systemctl enable sddm.service

systemctl enable --global zelideck-user-setup.service
