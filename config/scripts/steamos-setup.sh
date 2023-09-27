#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Steam setup
ln -s /usr/bin/steamos-logger /usr/bin/steamos-info
ln -s /usr/bin/steamos-logger /usr/bin/steamos-notice
ln -s /usr/bin/steamos-logger /usr/bin/steamos-warning
sed -i 's@/usr/bin/steam@/usr/bin/zelideck-steam@g' /usr/share/applications/steam.desktop
mkdir -p "/usr/etc/xdg/autostart"
cp "/usr/share/applications/steam.desktop" "/usr/etc/xdg/autostart/steam.desktop"
sed -i 's@/usr/bin/zelideck-steam %U@/usr/bin/zelideck-steam -silent %U@g' /usr/etc/xdg/autostart/steam.desktop
