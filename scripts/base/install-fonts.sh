#!/usrbin/env bash

set -ouex pipefail

# Install Hack Nerd Font
curl --output-dir /tmp -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip
mkdir -p /usr/share/fonts/Hack
unzip /tmp/Hack.zip -d /usr/share/fonts/Hack
fc-cache -f /usr/share/fonts/Hack
