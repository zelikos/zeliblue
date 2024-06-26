#!/usrbin/env bash

set -ouex pipefail

systemctl enable brew-setup.service
systemctl enable brew-upgrade.timer
systemctl enable brew-update.timer
systemctl enable com.system76.Scheduler.service
