#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Deck firmware

JUPITER_FIRMWARE_VERSION="jupiter-20240917.1"

mkdir -p /tmp/linux-firmware-neptune
curl -Lo /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-cali.bin https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_FIRMWARE_VERSION}"/cs35l41-dsp1-spk-cali.bin
curl -Lo /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-cali.wmfw https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_FIRMWARE_VERSION}"/cs35l41-dsp1-spk-cali.wmfw
curl -Lo /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-prot.bin https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_FIRMWARE_VERSION}"/cs35l41-dsp1-spk-prot.bin
curl -Lo /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-prot.wmfw https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_FIRMWARE_VERSION}"/cs35l41-dsp1-spk-prot.wmfw
xz --check=crc32 /tmp/linux-firmware-neptune/cs35l41-dsp1-spk-{cali.bin,cali.wmfw,prot.bin,prot.wmfw}
mv -vf /tmp/linux-firmware-neptune/* /usr/lib/firmware/cirrus/
rm -rf /tmp/linux-firmware-neptune
mkdir -p /tmp/linux-firmware-galileo
curl https://gitlab.com/evlaV/linux-firmware-neptune/-/archive/"${JUPITER_FIRMWARE_VERSION}"/linux-firmware-neptune-"${JUPITER_FIRMWARE_VERSION}".tar.gz?path=ath11k/QCA206X -o /tmp/linux-firmware-galileo/ath11k.tar.gz
tar --strip-components 1 --no-same-owner --no-same-permissions --no-overwrite-dir -xvf /tmp/linux-firmware-galileo/ath11k.tar.gz -C /tmp/linux-firmware-galileo
xz --check=crc32 /tmp/linux-firmware-galileo/ath11k/QCA206X/hw2.1/*
rm -f /usr/lib/firmware/ath11k/QCA206X/*
rm -rf /usr/lib/firmware/ath11k/QCA2066
mv -vf /tmp/linux-firmware-galileo/ath11k/QCA206X /usr/lib/firmware/ath11k/QCA206X
rm -rf /tmp/linux-firmware-galileo/ath11k
rm -rf /tmp/linux-firmware-galileo/ath11k.tar.gz
ln -s QCA206X /usr/lib/firmware/ath11k/QCA2066
curl -Lo /tmp/linux-firmware-galileo/hpbtfw21.tlv https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_FIRMWARE_VERSION}"/qca/hpbtfw21.tlv
curl -Lo /tmp/linux-firmware-galileo/hpnv21.309 https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_FIRMWARE_VERSION}"/qca/hpnv21.309
curl -Lo /tmp/linux-firmware-galileo/hpnv21.bin https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_FIRMWARE_VERSION}"/qca/hpnv21.bin
curl -Lo /tmp/linux-firmware-galileo/hpnv21g.309 https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_FIRMWARE_VERSION}"/qca/hpnv21g.309
curl -Lo /tmp/linux-firmware-galileo/hpnv21g.bin https://gitlab.com/evlaV/linux-firmware-neptune/-/raw/"${JUPITER_FIRMWARE_VERSION}"/qca/hpnv21g.bin
xz --check=crc32 /tmp/linux-firmware-galileo/*
mv -vf /tmp/linux-firmware-galileo/* /usr/lib/firmware/qca/
rm -rf /tmp/linux-firmware-galileo

# Dock updater
git clone https://gitlab.com/evlaV/jupiter-dock-updater-bin.git \
        --depth 1 \
        /tmp/jupiter-dock-updater-bin
mv -v /tmp/jupiter-dock-updater-bin/packaged/usr/lib/jupiter-dock-updater /usr/libexec/jupiter-dock-updater
rm -rf /tmp/jupiter-dock-updater-bin

# Steam setup
ln -s /usr/bin/steamos-logger /usr/bin/steamos-info
ln -s /usr/bin/steamos-logger /usr/bin/steamos-notice
ln -s /usr/bin/steamos-logger /usr/bin/steamos-warning
sed -i 's@/usr/bin/steam@/usr/bin/zelideck-steam@g' /usr/share/applications/steam.desktop
mkdir -p /etc/skel/.config/autostart/
cp "/usr/share/applications/steam.desktop" "/etc/xdg/autostart/steam.desktop"
sed -i 's@/usr/bin/zelideck-steam %U@/usr/bin/zelideck-steam -silent %U@g' /etc/xdg/autostart/steam.desktop

# Add bootstrap_steam.tar.gz used by gamescope-session (Thanks GE & Nobara Project!)
mkdir -p /usr/share/gamescope-session-plus/
curl -Lo /usr/share/gamescope-session-plus/bootstrap_steam.tar.gz https://large-package-sources.nobaraproject.org/bootstrap_steam.tar.gz
