#!/bin/bash

set -ouex pipefail


echo "===Applying overrides==="

# Hide launchers for CLI programs
for file in fish htop nvtop; do
    if [[ -f "/usr/share/applications/$file.desktop" ]]; then
        sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/"$file".desktop
    fi
done

# Swap to sudo-rs
if [[ $ZELIBLUE_IMAGE_TAG == "testing" ]]; then
  dnf5 -y install sudo-rs
  ln -sf /usr/bin/su-rs /usr/bin/su
  ln -sf /usr/bin/sudo-rs /usr/bin/sudo
  ln -sf /usr/bin/visudo-rs /usr/bin/visudo
fi

# Override files from Universal Blue
rsync -rvK /ctx/system_files/overrides/ /
