#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

export FLATPAKS_MODULE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cp -r "$FLATPAKS_MODULE_DIR"/files/bin/* /usr/bin/
cp -r "$FLATPAKS_MODULE_DIR"/files/systemd/* /usr/lib/systemd/

SYS_INSTALL_LIST=/usr/etc/flatpak/system/install
SYS_REMOVE_LIST=/usr/etc/flatpak/system/remove
SYS_REPO_INFO=/usr/etc/flatpak/system/repo-info.yml

USER_INSTALL_LIST=/usr/etc/flatpak/user/install
USER_REMOVE_LIST=/usr/etc/flatpak/user/remove
USER_REPO_INFO=/usr/etc/flatpak/user/repo-info.yml

echo "Enabling flatpaks module"
systemctl enable system-flatpak-setup.service
systemctl enable --global user-flatpak-setup.service
mkdir -p /usr/etc/flatpak/{system,user}

get_yaml_array SYSTEM_INSTALL '.system.install[]' "$1"
get_yaml_array SYSTEM_REMOVE '.system.remove[]' "$1"

REPO_URL=$(echo "$1" | yq -I=0 '.system.repo-url')
REPO_NAME=$(echo "$1" | yq -I=0 '.system.repo-name')
REPO_TITLE=$(echo "$1" | yq -I=0 '.system.repo-title')

touch $SYS_REPO_INFO
cat > $SYS_REPO_INFO <<EOF
repo-url: "$REPO_URL"
repo-name: "$REPO_NAME"
repo-title: "$REPO_TITLE"
EOF

get_yaml_array USER_INSTALL '.user.install[]' "$1"
get_yaml_array USER_REMOVE '.user.remove[]' "$1"

REPO_URL=$(echo "$1" | yq -I=0 '.user.repo-url')
REPO_NAME=$(echo "$1" | yq -I=0 '.user.repo-name')
REPO_TITLE=$(echo "$1" | yq -I=0 '.user.repo-title')

touch $USER_REPO_INFO
cat > $USER_REPO_INFO <<EOF
repo-url: "$REPO_URL"
repo-name: "$REPO_NAME"
repo-title: "$REPO_TITLE"
EOF

echo "Creating system Flatpak install list"
if [[ ${#SYSTEM_INSTALL[@]} -gt 0 ]]; then
    rm -f $SYS_INSTALL_LIST && touch $SYS_INSTALL_LIST
    for flatpak in "${SYSTEM_INSTALL[@]}"; do
        echo "Adding to system flatpak installs: $(printf ${flatpak})"
        echo $flatpak >> $SYS_INSTALL_LIST
    done
fi

echo "Creating system Flatpak removals list"
if [[ ${#SYSTEM_REMOVE[@]} -gt 0 ]]; then
    rm -f $SYS_REMOVE_LIST && touch $SYS_REMOVE_LIST
    for flatpak in "${SYSTEM_REMOVE[@]}"; do
        echo "Adding to system flatpak removals: $(printf ${flatpak})"
        echo $flatpak >> $SYS_REMOVE_LIST
    done
fi

echo "Creating user Flatpak install list"
if [[ ${#USER_INSTALL[@]} -gt 0 ]]; then
    rm -f $USER_INSTALL_LIST && touch $USER_INSTALL_LIST
    for flatpak in "${USER_INSTALL[@]}"; do
        echo "Adding to user flatpak installs: $(printf ${flatpak})"
        echo $flatpak >> $USER_INSTALL_LIST
    done
fi

echo "Creating user Flatpak removals list"
if [[ ${#USER_REMOVE[@]} -gt 0 ]]; then
    rm -f $USER_REMOVE_LIST && touch $USER_REMOVE_LIST
    for flatpak in "${USER_REMOVE[@]}"; do
        echo "Adding to user flatpak removals: $(printf ${flatpak})"
        echo $flatpak >> $USER_REMOVE_LIST
    done
fi
