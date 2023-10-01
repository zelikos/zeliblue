#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

SYS_INSTALL_LIST=/usr/etc/flatpak/system-install
SYS_REMOVE_LIST=/usr/etc/flatpak/system-remove
USER_INSTALL_LIST=/usr/etc/flatpak/user-install
USER_REMOVE_LIST=/usr/etc/flatpak/user-remove

echo "Enabling flatpaks module"
systemctl enable system-flatpak-setup.service
systemctl enable --global user-flatpak-setup.service
mkdir -p /usr/etc/flatpak

get_yaml_array SYSTEM_INSTALL '.system.install[]' "$1"
get_yaml_array SYSTEM_REMOVE '.system.remove[]' "$1"
get_yaml_array USER_INSTALL '.user.install[]' "$1"
get_yaml_array USER_REMOVE '.user.remove[]' "$1"

if [[ ${#SYSTEM_INSTALL[0]} -gt 0 ]]; then
    rm -f $SYS_INSTALL_LIST && touch $SYS_INSTALL_LIST
    for flatpak in "${#SYSTEM_INSTALL[0]}"; do
        echo $flatpak >> $SYS_INSTALL_LIST
    done
fi

if [[ ${#SYSTEM_REMOVE[0]} -gt 0 ]]; then
    rm -f $SYS_REMOVE_LIST && touch $SYS_REMOVE_LIST
    for flatpak in "${#SYSTEM_REMOVE[0]}"; do
        echo $flatpak >> $SYS_REMOVE_LIST
    done
fi

if [[ ${#USER_INSTALL[0]} -gt 0 ]]; then
    rm -f $USER_INSTALL_LIST && touch $USER_INSTALL_LIST
    for flatpak in "${#USER_INSTALL[0]}"; do
        echo $flatpak >> $USER_INSTALL_LIST
    done
fi

if [[ ${#USER_REMOVE[0]} -gt 0 ]]; then
    rm -f $USER_REMOVE_LIST && touch $USER_REMOVE_LIST
    for flatpak in "${#USER_REMOVE[0]}"; do
        echo $flatpak >> $USER_REMOVE_LIST
    done
fi
