#!/usrbin/env bash

set -ouex pipefail

. /tmp/base/image-info.sh
. /tmp/base/image-signing.sh
. /tmp/base/install-fonts.sh
. /tmp/base/base-packages.sh

systemctl enable com.system76.Scheduler.service
