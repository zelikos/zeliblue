#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

IMAGE_PRETTY_NAME="Zeliblue"
HOME_URL="https://github.com/zelikos/zeliblue"
DOCUMENTATION_URL=$HOME_URL
SUPPORT_URL="https://github.com/zelikos/zeliblue/issues"
BUG_REPORT_URL=$SUPPORT_URL

IMAGE_INFO="/usr/share/zeliblue/image-info.json"
IMAGE_VENDOR="zelikos"
IMAGE_REF="ostree-image-signed:docker://ghcr.io/$IMAGE_VENDOR/$IMAGE_NAME"
IMAGE_FLAVOR=""
IMAGE_TAG="latest"

if grep -q "kinoite" <<< "${BASE_IMAGE}"; then
  IMAGE_FLAVOR="kinoite"
else
  IMAGE_FLAVOR="silverblue"
fi

cat > $IMAGE_INFO <<EOF
{
  "image-name": "$IMAGE_NAME",
  "image-flavor": "$IMAGE_FLAVOR",
  "image-vendor": "$IMAGE_VENDOR",
  "image-ref": "$IMAGE_REF",
  "image-tag":"$IMAGE_TAG",
  "base-image-name": "$BASE_IMAGE",
  "fedora-version": "$OS_VERSION"
}
EOF

# OS Release File
sed -i "s/^VARIANT_ID=.*/VARIANT_ID=$IMAGE_NAME/" /usr/lib/os-release
sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"Zeliblue (FROM Fedora ${BASE_IMAGE^} $OS_VERSION)\"/" /usr/lib/os-release
sed -i "s/^NAME=.*/NAME=\"$IMAGE_PRETTY_NAME\"/" /usr/lib/os-release
sed -i "s|^HOME_URL=.*|HOME_URL=\"$HOME_URL\"|" /usr/lib/os-release
sed -i "s|^DOCUMENTATION_URL=.*|DOCUMENTATION_URL=\"$DOCUMENTATION_URL\"|" /usr/lib/os-release
sed -i "s|^SUPPORT_URL=.*|SUPPORT_URL=\"$SUPPORT_URL\"|" /usr/lib/os-release
sed -i "s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"$BUG_REPORT_URL\"|" /usr/lib/os-release
# sed -i "s|^CPE_NAME=\"cpe:/o:fedoraproject:fedora|CPE_NAME=\"cpe:/o:universal-blue:${IMAGE_PRETTY_NAME,}|" /usr/lib/os-release
sed -i "s/^DEFAULT_HOSTNAME=.*/DEFAULT_HOSTNAME=\"${IMAGE_PRETTY_NAME,}\"/" /usr/lib/os-release
sed -i "s/^ID=fedora/ID=${IMAGE_PRETTY_NAME,}\nID_LIKE=\"rhel centos fedora\"/" /usr/lib/os-release
# sed -i "s/^LOGO=.*/LOGO=$LOGO_ICON/" /usr/lib/os-release
# sed -i "s/^ANSI_COLOR=.*/ANSI_COLOR=\"$LOGO_COLOR\"/" /usr/lib/os-release
sed -i "/^REDHAT_BUGZILLA_PRODUCT=/d; /^REDHAT_BUGZILLA_PRODUCT_VERSION=/d; /^REDHAT_SUPPORT_PRODUCT=/d; /^REDHAT_SUPPORT_PRODUCT_VERSION=/d" /usr/lib/os-release
