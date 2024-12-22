#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Steam setup
git clone https://gitlab.com/evlaV/jupiter-dock-updater-bin.git \
        --depth 1 \
        /tmp/jupiter-dock-updater-bin
mv -v /tmp/jupiter-dock-updater-bin/packaged/usr/lib/jupiter-dock-updater /usr/libexec/jupiter-dock-updater
rm -rf /tmp/jupiter-dock-updater-bin
ln -s /usr/bin/steamos-logger /usr/bin/steamos-info
ln -s /usr/bin/steamos-logger /usr/bin/steamos-notice
ln -s /usr/bin/steamos-logger /usr/bin/steamos-warning
sed -i 's@/usr/bin/steam@/usr/bin/zelideck-steam@g' /usr/share/applications/steam.desktop
mkdir -p /etc/skel/.config/autostart/
cp "/usr/share/applications/steam.desktop" "/etc/skel/.config/autostart/steam.desktop"
sed -i 's@/usr/bin/zelideck-steam %U@/usr/bin/zelideck-steam -silent %U@g' /etc/skel/.config/autostart/steam.desktop
