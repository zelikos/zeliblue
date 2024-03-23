#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

IMAGE_INFO="/usr/share/zeliblue/image-info.json"
IMAGE_VENDOR="zelikos"
IMAGE_REF="ostree-image-signed:docker://$IMAGE_VENDOR/$IMAGE_NAME"

if grep -q "silverblue" <<< "${BASE_IMAGE}"
then
  sed -i '/^PRETTY_NAME/s/Silverblue/Zeliblue/' /usr/lib/os-release
elif grep -q "kinoite" <<< "${BASE_IMAGE}"
then
  sed -i '/^PRETTY_NAME/s/Kinoite/Zeliblue Plasma/' /usr/lib/os-release
fi

cat > $IMAGE_INFO <<EOF
{
  "image-name": "$IMAGE_NAME",
  "image-flavor": "$IMAGE_FLAVOR",
  "image-vendor": "$IMAGE_VENDOR",
  "image-ref": "$IMAGE_REF",
  "image-tag":"$IMAGE_TAG",
  "base-image-name": "$BASE_IMAGE",
  "fedora-version": "$FEDORA_MAJOR_VERSION"
}
EOF