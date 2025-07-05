#!/bin/bash

set -ouex pipefail


echo "===Applying overrides==="

# Hide launchers for CLI programs
for file in fish htop nvtop; do
    if [[ -f "/usr/share/applications/$file.desktop" ]]; then
        sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/"$file".desktop
    fi
done

# Override files from Universal Blue
rsync -rvK /ctx/system_files/overrides/ /
