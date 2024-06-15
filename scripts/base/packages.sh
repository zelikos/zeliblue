#!/usrbin/env bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

curl -Lo /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/repo/fedora-"${RELEASE}"/kylegospo-system76-scheduler-fedora-"${RELEASE}".repo

# GNOME edition
curl -Lo /etc/yum.repos.d/_copr_kylegospo-bazzite.repo https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite/repo/fedora-"${RELEASE}"/kylegospo-bazzite-fedora-"${RELEASE}".repo

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Base packages
rpm-ostree install fish gcc glow gum jetbrains-mono-fonts rsms-inter-fonts rsms-inter-vf-fonts system76-scheduler

# GNOME packages
rpm-ostree install gnome-console gnome-shell-extension-hotedge gnome-shell-extension-system76-scheduler

# Package removals
rpm-ostree override remove firefox firefox-langpacks

# GNOME package removals
rpm-ostree override remove gnome-classic-session gnome-classic-session-xsession gnome-software-rpm-ostree gnome-terminal gnome-terminal-nautilus gnome-tweaks
