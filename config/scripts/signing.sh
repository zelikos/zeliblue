#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

IMAGE_VENDOR=zelikos
IMAGE_TAG=latest # Leaving as a variable in case of future changes
IMAGE_INFO=/usr/share/ublue-os/image-info.json

echo "Setting up container signing in policy.json and cosign.yaml for $IMAGE_NAME"
echo "Registry to write: $IMAGE_REGISTRY"

cp /usr/share/ublue-os/cosign.pub /usr/etc/pki/containers/"$IMAGE_VENDOR".pub

FILE=/usr/etc/containers/policy.json

yq -i -o=j '.transports.docker |=
    {"'"$IMAGE_REGISTRY"'": [
            {
                "type": "sigstoreSigned",
                "keyPath": "/usr/etc/pki/containers/'"$IMAGE_VENDOR"'.pub",
                "signedIdentity": {
                    "type": "matchRepository"
                }
            }
        ]
    }
+ .' "$FILE"

IMAGE_REF="ostree-image-signed:docker://$IMAGE_REGISTRY/$IMAGE_NAME"
# printf '{\n"image-ref": "'"$IMAGE_REF"'",\n"image-tag": "latest"\n}' > /usr/share/ublue-os/image-info.json

touch $IMAGE_INFO
cat > $IMAGE_INFO <<EOF
{
    "image-name": "$IMAGE_NAME",
    "image-flavor": "$BASE_IMAGE",
    "image-vendor": "$IMAGE_VENDOR",
    "image-ref": "$IMAGE_REF",
    "image-tag": "$IMAGE_TAG",
    "fedora-version": "$OS_VERSION"
}
EOF

if grep -q "silverblue" <<< "${BASE_IMAGE}"
then
  sed -i '/^PRETTY_NAME/s/Silverblue/Zeliblue/' /usr/lib/os-release
elif grep -q "kinoite" <<< "${BASE_IMAGE}"
then
  sed -i '/^PRETTY_NAME/s/Kinoite/Zeliblue Plasma/' /usr/lib/os-release
fi

cp /usr/etc/containers/registries.d/ublue-os.yaml /usr/etc/containers/registries.d/"$IMAGE_VENDOR".yaml
sed -i "s ghcr.io/ublue-os $IMAGE_REGISTRY g" /usr/etc/containers/registries.d/"$IMAGE_VENDOR".yaml
