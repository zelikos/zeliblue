#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Workaround for regression with dnf5
# https://github.com/rpm-software-management/dnf5/issues/2134
dnf5 -y downgrade dnf5-5.2.10.0-2.fc41

dnf5 -y copr enable bazzite-org/bazzite
dnf5 -y copr enable bazzite-org/bazzite-multilib
dnf5 -y copr enable lizardbyte/beta
dnf5 -y copr enable ublue-os/staging
dnf5 -y copr enable ycollet/audinux
dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release{,-extras}

dnf5 -y swap --repo terra-extras mesa-filesystem mesa-filesystem
dnf5 -y swap --repo copr:copr.fedorainfracloud.org:bazzite-org:bazzite-multilib pipewire pipewire
dnf5 -y swap --repo copr:copr.fedorainfracloud.org:bazzite-org:bazzite-multilib bluez bluez
dnf5 -y swap --repo copr:copr.fedorainfracloud.org:bazzite-org:bazzite-multilib xorg-x11-server-Xwayland xorg-x11-server-Xwayland
dnf5 -y swap --repo copr:copr.fedorainfracloud.org:bazzite-org:bazzite ibus ibus
dnf5 -y swap --repo copr:copr.fedorainfracloud.org:bazzite-org:bazzite upower upower

dnf5 versionlock add \
        pipewire \
        pipewire-alsa \
        pipewire-gstreamer \
        pipewire-jack-audio-connection-kit \
        pipewire-jack-audio-connection-kit-libs \
        pipewire-libs \
        pipewire-plugin-libcamera \
        pipewire-pulseaudio \
        pipewire-utils \
        bluez \
        bluez-cups \
        bluez-libs \
        bluez-obexd \
        xorg-x11-server-Xwayland \
        switcheroo-control \
        mesa-dri-drivers \
        mesa-filesystem \
        mesa-libEGL \
        mesa-libGL \
        mesa-libgbm \
        mesa-libglapi \
        mesa-va-drivers \
        mesa-vulkan-drivers \
        ibus \
        upower \
        upower-libs

dnf5 -y install \
  ds-inhibit \
  extest.i686 \
  galileo-mura \
  gamescope.x86_64 \
  gamescope-libs.x86_64 \
  gamescope-libs.i686 \
  gamescope-shaders \
  jupiter-fan-control \
  jupiter-hw-support-btrfs \
  ladspa-caps-plugins \
  ladspa-noise-suppression-for-voice \
  mangohud \
  pipewire-module-filter-chain-sofa \
  powerbuttond \
  scx-scheds \
  sdgyrodsu \
  sddm \
  steam \
  steam_notif_daemon \
  steamdeck-gnome-presets \
  steamdeck-dsp \
  sunshine \
  vkbasalt \
  vpower \
  ublue-update

# Add bootstrap_steam.tar.gz used by gamescope-session (Thanks GE & Nobara Project!)
mkdir -p /usr/share/gamescope-session-plus/
curl -Lo /usr/share/gamescope-session-plus/bootstrap_steam.tar.gz https://large-package-sources.nobaraproject.org/bootstrap_steam.tar.gz

dnf5 -y install --repo copr:copr.fedorainfracloud.org:bazzite-org:bazzite \
  gamescope-session-plus \
  gamescope-session-steam
