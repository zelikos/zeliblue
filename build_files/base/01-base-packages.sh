#!/bin/bash

set -ouex pipefail

echo "===Enabling extra repositories==="

dnf5 -y copr enable ublue-os/packages
dnf5 -y copr enable ublue-os/staging

# use negativo17 for 3rd party packages with higher priority than default
if ! grep -q fedora-multimedia <(dnf5 repolist); then
    # Enable or Install Repofile
    dnf5 config-manager setopt fedora-multimedia.enabled=1 ||
        dnf5 config-manager addrepo --from-repofile="https://negativo17.org/repos/fedora-multimedia.repo"
fi
# Set higher priority
dnf5 config-manager setopt fedora-multimedia.priority=90


echo "===Installing packages==="

# uBlue packages
dnf5 -y install \
  ublue-os-just \
  ublue-os-luks \
  ublue-polkit-rules \
  ublue-os-signing \
  ublue-os-udev-rules

# Batteries included
dnf5 -y install \
  alsa-firmware \
  android-udev-rules \
  distrobox \
  fdk-aac \
  ffmpeg \
  ffmpeg-libs \
  ffmpegthumbnailer \
  flatpak-spawn \
  fzf \
  heif-pixbuf-loader \
  htop \
  intel-vaapi-driver \
  libavcodec \
  libcamera-tools \
  libcamera-gstreamer \
  libfdk-aac \
  libheif \
  libratbag-ratbagd \
  lshw \
  nvtop \
  openrgb-udev-rules \
  openssl \
  pam-u2f \
  pam_yubico \
  pamu2fcfg \
  pipewire-libs-extra \
  solaar-udev \
  traceroute \
  wireguard-tools \
  yubikey-manager \
  zstd

# Batteries included - for GNOME
dnf -y install \
  gvfs-nfs

dnf5 -y remove \
  firefox \
  firefox-langpacks \
  gnome-software-rpm-ostree \
  totem-video-thumbnailer

dnf5 -y swap \
  --repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
  fwupd fwupd
