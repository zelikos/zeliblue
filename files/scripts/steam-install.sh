#!/usr/bin/env bash

set -oue pipefail

# Based on Bazzite's solution for installing Steam without package conflicts: https://github.com/ublue-os/bazzite/pull/330

echo "Setting up repositories..."

sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/negativo17-fedora-multimedia.repo
curl -Lo /etc/yum.repos.d/negativo17-fedora-steam.repo https://negativo17.org/repos/fedora-steam.repo && \
curl -Lo /etc/yum.repos.d/negativo17-fedora-rar.repo https://negativo17.org/repos/fedora-rar.repo
curl -Lo /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite-multilib/repo/fedora-"${OS_VERSION}"/kylegospo-bazzite-multilib-fedora-"${OS_VERSION}".repo?arch=x86_64

# Ensure that needed Mesa packages are installed from bazzite-multilib
echo "Installing Mesa packages from bazzite-multilib"

rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib \
      mesa-libxatracker \
      mesa-libglapi \
      mesa-dri-drivers \
      mesa-libgbm \
      mesa-libEGL \
      mesa-vulkan-drivers \
      mesa-libGL \
      pipewire \
      pipewire-alsa \
      pipewire-gstreamer \
      pipewire-jack-audio-connection-kit \
      pipewire-jack-audio-connection-kit-libs \
      pipewire-libs \
      pipewire-pulseaudio \
      pipewire-utils \
      pipewire-plugin-libcamera \
      bluez \
      bluez-obexd \
      bluez-cups \
      bluez-libs \
      xorg-x11-server-Xwayland

echo "Installing other Steam dependencies"

rpm-ostree install \
  jupiter-sd-mounting-btrfs \
  at-spi2-core.i686 \
  atk.i686 \
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
  pipewire-alsa.i686 \
  gobject-introspection \
  steam

# Add bootstrap_steam.tar.gz used by gamescope-session (Thanks GE & Nobara Project!)
mkdir -p /usr/share/gamescope-session-plus/
curl -Lo /usr/share/gamescope-session-plus/bootstrap_steam.tar.gz https://large-package-sources.nobaraproject.org/bootstrap_steam.tar.gz


# Cleanup
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo
