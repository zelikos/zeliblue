#!/usr/bin/bash

set -eoux pipefail

if [[ "${KERNEL_FLAVOR}" == "surface" ]]; then
    KERNEL_SUFFIX="surface"
else
    KERNEL_SUFFIX=""
fi

QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(|'"$KERNEL_SUFFIX"'-)(\d+\.\d+\.\d+)' | sed -E 's/kernel-(|'"$KERNEL_SUFFIX"'-)//')"
/usr/bin/dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible --zstd -v --add ostree -f "/lib/modules/$QUALIFIED_KERNEL/initramfs.img"

chmod 0600 /lib/modules/$QUALIFIED_KERNEL/initramfs.img
