#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

dnf5 -y copr enable kylegospo/bazzite
dnf5 -y copr enable kylegospo/bazzite-multilib
dnf5 -y copr enable lizardbyte/beta
dnf5 -y copr enable ublue-os/staging
dnf5 -y copr enable ycollet/audinux
dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release{,-extras}

dnf5 -y swap --repo terra-extras mesa-filesystem mesa-filesystem
dnf5 -y swap --repo copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib pipewire pipewire
dnf5 -y swap --repo copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib bluez bluez
dnf5 -y swap --repo copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib xorg-x11-server-Xwayland xorg-x11-server-Xwayland
dnf5 -y swap --repo copr:copr.fedorainfracloud.org:kylegospo:bazzite ibus ibus
dnf5 -y swap --repo copr:copr.fedorainfracloud.org:kylegospo:bazzite upower upower

dnf5 -y install \
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
  vpower

# Add bootstrap_steam.tar.gz used by gamescope-session (Thanks GE & Nobara Project!)
mkdir -p /usr/share/gamescope-session-plus/
curl -Lo /usr/share/gamescope-session-plus/bootstrap_steam.tar.gz https://large-package-sources.nobaraproject.org/bootstrap_steam.tar.gz

dnf5 -y install --repo copr:copr.fedorainfracloud.org:kylegospo:bazzite \
  gamescope-session-plus \
  gamescope-session-steam
