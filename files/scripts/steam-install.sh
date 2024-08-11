#!/usr/bin/env bash

set -oue pipefail

# Based on Bazzite's Containerfile: https://github.com/ublue-os/bazzite/blob/main/Containerfile

rpm-ostree override replace \
--experimental \
--from repo=updates \
    vulkan-loader \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    alsa-lib \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    gnutls \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    glib2 \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    nspr \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    nss-softokn \
    nss-softokn-freebl \
    nss-util \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    atk \
    at-spi2-atk \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    libaom \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    gstreamer1 \
    gstreamer1-plugins-base \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    libdecor \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    libtirpc \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    libuuid \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    libblkid \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    libmount \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    cups-libs \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    libinput \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    libopenmpt \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    llvm-libs \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    zlib-ng-compat \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    fontconfig \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    pciutils-libs \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    libdrm \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    libX11 \
    libX11-common \
    libX11-xcb \
    || true && \
rpm-ostree override replace \
--experimental \
--from repo=updates \
    libv4l \
    || true && \
rpm-ostree override remove \
    glibc32 \
    || true

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

# Setup Gamescope
rpm-ostree install \
    gamescope \
    gamescope-legacy \
    gamescope-libs.i686 \
    gamescope-shaders

# Add bootstrap_steam.tar.gz used by gamescope-session (Thanks GE & Nobara Project!)
mkdir -p /usr/share/gamescope-session-plus/
curl -Lo /usr/share/gamescope-session-plus/bootstrap_steam.tar.gz https://large-package-sources.nobaraproject.org/bootstrap_steam.tar.gz
rpm-ostree install gamescope-session-plus gamescope-session-steam

# Cleanup
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo
