#!/usrbin/env bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

curl -Lo /etc/yum.repos.d/_copr_kylegospo-bazzite.repo https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite/repo/fedora-"${RELEASE}"/kylegospo-bazzite-fedora-"${RELEASE}".repo

# GNOME packages
rpm-ostree install gnome-console gnome-shell-extension-hotedge gnome-shell-extension-system76-scheduler

# GNOME package removals
rpm-ostree override remove gnome-classic-session gnome-classic-session-xsession gnome-software-rpm-ostree gnome-terminal gnome-terminal-nautilus gnome-tweaks
