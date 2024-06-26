#!/usrbin/env bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

curl -Lo /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/repo/fedora-"${RELEASE}"/kylegospo-system76-scheduler-fedora-"${RELEASE}".repo

curl -Lo /etc/yum.repos.d/_copr_ublue-os-staging.repo https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-"${RELEASE}"/ublue-os-staging-fedora-"${RELEASE}".repo?arch=x86_64

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Base packages

# Required for ublue-update
rpm-ostree install python3-pip
pip install --prefix=/usr topgrade

rpm-ostree install fish gcc glow gum rsms-inter-fonts rsms-inter-vf-fonts system76-scheduler ublue-update

# Package removals

rpm-ostree override remove firefox firefox-langpacks ublue-os-update-services
