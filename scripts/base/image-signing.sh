#!/usrbin/env bash

set -ouex pipefail

IMAGE_NAME=zeliblue
IMAGE_REGISTRY=ghcr.io/zelikos
IMAGE_INFO=/usr/share/zeliblue/image-info.json

echo "Setting up container signing in policy.json and cosign.yaml for $IMAGE_NAME"
echo "Registry to write: $IMAGE_REGISTRY"

cp /usr/share/ublue-os/cosign.pub /usr/etc/pki/containers/"$IMAGE_NAME".pub

FILE=/usr/etc/containers/policy.json

jq '.transports.docker |=
    {"'"$IMAGE_REGISTRY"'/'"$IMAGE_NAME"'": [
            {
                "type": "sigstoreSigned",
                "keyPath": "/usr/etc/pki/containers/'"$IMAGE_NAME"'.pub",
                "signedIdentity": {
                    "type": "matchRepository"
                }
            }
        ]
    }
+ .' "$FILE"

cp /usr/etc/containers/registries.d/ublue-os.yaml /usr/etc/containers/registries.d/"$IMAGE_NAME".yaml
sed -i "s ghcr.io/ublue-os $IMAGE_REGISTRY g" /usr/etc/containers/registries.d/"$IMAGE_NAME".yaml
