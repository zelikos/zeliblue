#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

echo "===Installing kernel==="

# Remove Existing Kernel
dnf5 -y remove kernel-{core,modules,modules-core,modules-extra,tools,tools-libs}

# Fetch Common AKMODS & Kernel RPMS
skopeo copy --retry-times 3 docker://ghcr.io/ublue-os/akmods:"${AKMODS_FLAVOR}"-"$(rpm -E %fedora)" dir:/tmp/akmods
AKMODS_TARGZ=$(jq -r '.layers[].digest' </tmp/akmods/manifest.json | cut -d : -f 2)
tar -xvzf /tmp/akmods/"$AKMODS_TARGZ" -C /tmp/
mv /tmp/rpms/* /tmp/akmods/
# NOTE: kernel-rpms should auto-extract into correct location

# Install Kernel
dnf5 -y install \
  /tmp/kernel-rpms/kernel-[0-9]*.rpm \
  /tmp/kernel-rpms/kernel-core-*.rpm \
  /tmp/kernel-rpms/kernel-modules-*.rpm

dnf5 versionlock add kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra

# Install akmods
dnf5 -y copr enable ublue-os/akmods

dnf5 -y install /tmp/akmods/kmods/*framework-laptop*.rpm

if [[ $AKMODS_FLAVOR == "bazzite" ]]; then
  # Fetch Extra AKMODS
  skopeo copy --retry-times 3 docker://ghcr.io/ublue-os/akmods-extra:"${AKMODS_FLAVOR}"-"$(rpm -E %fedora)" dir:/tmp/akmods-extra
  AKMODS_TARGZ=$(jq -r '.layers[].digest' </tmp/akmods-extra/manifest.json | cut -d : -f 2)
  tar -xvzf /tmp/akmods-extra/"$AKMODS_TARGZ" -C /tmp/
  mv /tmp/rpms/* /tmp/akmods-extra/

  dnf5 -y install \
      /tmp/akmods-extra/kmods/*zenergy*.rpm \
      /tmp/akmods-extra/kmods/*ryzen-smu*.rpm
fi

dnf5 -y copr remove ublue-os/akmods
