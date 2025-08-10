#!/bin/bash

set -ouex pipefail

echo "===Enabling extra repositories==="

dnf5 -y copr enable ublue-os/staging
dnf5 -y copr enable bazzite-org/bazzite
dnf5 -y copr enable bazzite-org/bazzite-multilib
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons
dnf5 -y copr enable lizardbyte/beta
dnf5 -y copr enable ycollet/audinux

dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release{,-extras}
dnf5 config-manager setopt terra-mesa.enabled=1

echo "===Installing packages==="

dnf5 -y swap \
  --repo=terra-mesa \
  mesa-filesystem mesa-filesystem

# Swap packages from bazzite-multilib
for package in bluez xorg-x11-server-Xwayland; do
  dnf5 -y swap \
    --repo=copr:copr.fedorainfracloud.org:bazzite-org:bazzite-multilib \
    $package $package
done

# Swap packages from bazzite
for package in ibus upower wireplumber wireplumber-libs; do
  dnf5 -y swap \
    --repo=copr:copr.fedorainfracloud.org:bazzite-org:bazzite \
    $package $package
done

# Lock swapped package versions
dnf5 versionlock add bluez bluez-cups bluez-libs bluez-obexd xorg-x11-server-Xwayland switcheroo-control mesa-dri-drivers mesa-filesystem mesa-libEGL mesa-libGL mesa-libgbm mesa-libglapi mesa-va-drivers mesa-vulkan-drivers ibus upower upower-libs

dnf5 -y install \
  ds-inhibit \
  extest.i686 \
  galileo-mura \
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
  steam_notif_daemon \
  steamdeck-dsp \
  steamdeck-gnome-presets \
  sunshine \
  vkbasalt \
  vpower

dnf5 -y --setopt=install_weak_deps=False install \
  steam

# dnf5 -y copr disable bazzite-org/bazzite-multilib
dnf5 -y install gamescope

dnf5 -y install \
  --repo copr:copr.fedorainfracloud.org:bazzite-org:bazzite \
  gamescope-session-plus gamescope-session-steam
