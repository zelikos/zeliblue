#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

export FLATPAKS_MODULE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cp -r "$FLATPAKS_MODULE_DIR"/files/bin/* /usr/bin/
cp -r "$FLATPAKS_MODULE_DIR"/files/systemd/* /usr/lib/systemd/

echo "Enabling flatpaks module"
systemctl enable system-flatpak-setup.service
systemctl enable --global user-flatpak-setup.service
mkdir -p /usr/etc/flatpak/{system,user}

configure_flatpak_repo () {
    CONFIG_FILE=$1
    INSTALL_LEVEL=$2
    REPO_INFO="/usr/etc/flatpak/$INSTALL_LEVEL/repo-info.yml"
    # If REPO_INFO already exists, don't re-create it
    if [[ ! -f $REPO_INFO ]]; then
        echo "Configuring $INSTALL_LEVEL repo in $REPO_INFO"
        REPO_URL=$(echo "$CONFIG_FILE" | yq -I=0 ".$INSTALL_LEVEL.repo-url")
        REPO_NAME=$(echo "$CONFIG_FILE" | yq -I=0 ".$INSTALL_LEVEL.repo-name")
        REPO_TITLE=$(echo "$CONFIG_FILE" | yq -I=0 ".$INSTALL_LEVEL.repo-title")

        # Use Flathub as default repo
        if [[ $REPO_URL == "null" ]]; then
            REPO_URL=https://dl.flathub.org/repo/flathub.flatpakrepo
        fi

        # If repo-name isn't configured, use flathub as fallback
        # Checked separately from URL to allow custom naming
        if [[ $REPO_NAME == "null" ]]; then
            REPO_NAME="flathub"
        fi

        touch $REPO_INFO
        # EOF breaks if the contents are indented,
        # so the below lines are intentionally un-indented
        cat > $REPO_INFO <<EOF
repo-url: "$REPO_URL"
repo-name: "$REPO_NAME"
repo-title: "$REPO_TITLE"
EOF
    fi
}

configure_lists () {
    CONFIG_FILE=$1
    INSTALL_LEVEL=$2
    INSTALL_LIST="/usr/etc/flatpak/$INSTALL_LEVEL/install"
    REMOVE_LIST="/usr/etc/flatpak/$INSTALL_LEVEL/remove"
    get_yaml_array INSTALL ".$INSTALL_LEVEL.install[]" "$CONFIG_FILE"
    get_yaml_array REMOVE ".$INSTALL_LEVEL.remove[]" "$CONFIG_FILE"

    echo "Creating $INSTALL_LEVEL Flatpak install list at $INSTALL_LIST"
    if [[ ${#INSTALL[@]} -gt 0 ]]; then
        touch $INSTALL_LIST
        for flatpak in "${INSTALL[@]}"; do
            echo "Adding to $INSTALL_LEVEL flatpak installs: $(printf ${flatpak})"
            echo $flatpak >> $INSTALL_LIST
        done
    fi

    echo "Creating $INSTALL_LEVEL Flatpak removals list $REMOVE_LIST"
    if [[ ${#REMOVE[@]} -gt 0 ]]; then
        touch $REMOVE_LIST
        for flatpak in "${REMOVE[@]}"; do
            echo "Adding to $INSTALL_LEVEL flatpak removals: $(printf ${flatpak})"
            echo $flatpak >> $REMOVE_LIST
        done
    fi
}

# Check that `system` is present before configuring
if [[ ! $(echo "$1" | yq -I=0 ".system") == "null" ]]; then
    configure_flatpak_repo "$1" "system"
    configure_lists "$1" "system"
fi

# Check that `user` is present before configuring
if [[ ! $(echo "$1" | yq -I=0 ".user") == "null" ]]; then
    configure_flatpak_repo "$1" "user"
    configure_lists "$1" "user"
fi
