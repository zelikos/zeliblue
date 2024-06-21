#!/usr/bin/env bash

set -oue pipefail

# Based on Bazzite's solution for installing Steam without package conflicts: https://github.com/ublue-os/bazzite/pull/330


# Enable bazzite-multilib for their build of Mesa, and for extest later.
echo "Adding bazzite-multilib repository"

wget https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite-multilib/repo/fedora-${OS_VERSION}/kylegospo-bazzite-multilib-fedora-${OS_VERSION}.repo?arch=x86_64 -O /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo

# Ensure that needed Mesa packages are installed from bazzite-multilib
echo "Installing Mesa packages from bazzite-multilib"

rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib \
        mesa-filesystem \
        mesa-dri-drivers \
        mesa-libEGL \
        mesa-libEGL-devel \
        mesa-libgbm \
        mesa-libGL \
        mesa-libglapi \
        mesa-vulkan-drivers \

# Install other 32-bit Steam dependencies

echo "Installing other Steam dependencies"

rpm-ostree install \
	extest.i686 \
	gamescope-libs.i686 \
    vulkan-loader.i686 \
    alsa-lib.i686 \
    fontconfig.i686 \
    gtk2.i686 \
    libICE.i686 \
    libnsl.i686 \
    libxcrypt-compat.i686 \
    libpng12.i686 \
    libXext.i686 \
    libXinerama.i686 \
    libXtst.i686 \
    libXScrnSaver.i686 \
    NetworkManager-libnm.i686 \
    nss.i686 \
    pulseaudio-libs.i686 \
    libcurl.i686 \
    systemd-libs.i686 \
    libva.i686 \
    libvdpau.i686 \
    libdbusmenu-gtk3.i686 \
    libatomic.i686 \
    pipewire-alsa.i686

echo "Installing Steam"

sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree-steam.repo
sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree.repo
sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-updates.repo
sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/fedora-updates.repo
rpm-ostree install steam
sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-steam.repo
sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree.repo
sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree-updates.repo
sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/fedora-updates.repo

# Cleanup
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo
