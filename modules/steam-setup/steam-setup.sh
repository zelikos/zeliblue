#!/usr/bin/env bash
set -oue pipefail


# Based on Bazzite's solution for installing Steam without package conflicts: https://github.com/ublue-os/bazzite/pull/330
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

rpm-ostree install mesa-va-drivers

rpm-ostree install \
    mesa-dri-drivers.i686 \
    mesa-vulkan-drivers.i686 \
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
    mesa-libGL.i686 \
    mesa-libEGL.i686 \
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

sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree-steam.repo
sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree.repo
sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-updates.repo
sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/fedora-updates.repo
rpm-ostree install steam
sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-steam.repo
sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree.repo
sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree-updates.repo
sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/fedora-updates.repo
