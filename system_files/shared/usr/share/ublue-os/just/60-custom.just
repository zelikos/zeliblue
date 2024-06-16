# Include some of your custom scripts here!

# Install a small selection of CLI utilties via brew
zeliblue-cli:
  #!/usr/bin/bash
  source /usr/lib/ujust/ujust.sh

  OPTION=""
  echo "zeliblue-cli installs a handful of packages via brew,"
  echo "intended to provide a more modern CLI experience."
  echo "The full list can be found in the Brewfile at"
  echo "$HOME/.local/share/zeliblue/Brewfile"
  echo ""
  echo "The fish shell is pre-configured by Zeliblue"
  echo "to integrate these utilities if they are installed."
  echo ""
  echo "Proceed with installation?"
  OPTION=$(ugum choose Yes No)
  if [ "${OPTION,,}" == "yes" ]; then
    if [[ ! -f $HOME/.local/share/zeliblue/Brewfile ]]; then
      mkdir -p $HOME/.local/share/zeliblue
      cp /usr/etc/skel/.local/share/zeliblue/Brewfile $HOME/.local/share/zeliblue/Brewfile
    fi
    echo "Installing Zeliblue CLI utilities..."
    brew bundle --file=$HOME/.local/share/zeliblue/Brewfile
    echo "Installation complete. Please restart your terminal."
  fi

# Setup DaVinciBox container
setup-davincibox mode="":
  #!/usr/bin/env bash
  if [[ $(echo {{mode}}) == "refresh" ]]; then
    podman container stop davincibox
    podman container rm davincibox
  fi
  podman image pull ghcr.io/zelikos/davincibox:latest
  toolbox create -i ghcr.io/zelikos/davincibox:latest -c davincibox

# Install DaVinci Resolve to DaVinciBox
install-davinci installer="":
  #!/usr/bin/env bash
  EXISTS=$(podman ps --all --filter name="davincibox" | grep -q " davincibox\$" && echo "1" || echo "0")
  if [[ $EXISTS == "0" ]]; then
    just setup-davincibox
  else
    just setup-davincibox refresh
  fi

  INSTALLER_FILE=$(readlink -e {{installer}})

  if [[ $(echo $INSTALLER_FILE) == "" ]]; then
    echo "Please re-run this command with the full path to the DaVinci Resolve's installer."
    echo "Example:"
    echo "just install-davinci /full/path/to/DaVinci_Resolve_18.5.1_Linux.run"
  else
    $INSTALLER_FILE --appimage-extract
    toolbox run --container davincibox setup-davinci "squashfs-root/AppRun" toolbox
    rm -rf squashfs-root/
  fi

# Remove DaVinci Resolve and DaVinciBox
remove-davinci:
  #!/usr/bin/env bash
  toolbox run --container davincibox add-davinci-launcher remove
  podman container stop davincibox
  podman container rm davincibox

# Toggle Zeliblue-CLI container
zeliblue-cli-container ACTION="prompt":
  #!/usr/bin/bash
  source /usr/lib/ujust/ujust.sh
  CURRENT_STATE="Disabled"
  if systemctl --quiet --user is-active zeliblue-cli.service; then
    CURRENT_STATE="Enabled"
  fi
  OPTION={{ ACTION }}
  if [ "$OPTION" == "prompt" ]; then
    echo "Zeliblue CLI container is currently: ${bold}${CURRENT_STATE}${normal}"
    echo "Enable or Disable Zeliblue CLI container?"
    OPTION=$(ugum choose Enable Disable)
  elif [ "$OPTION" == "help" ]; then
    echo "Usage: ujust zeliblue-cli <option>"
    echo "  <option>: Specify the quick option - 'enable' or 'disable'"
    echo "  Use 'enable' to Enable the Zeliblue CLI container."
    echo "  Use 'disable' to Disable the Zeliblue CLI container."
    exit 0
  fi
  if [ "${OPTION,,}" == "enable" ]; then
    just enable-zeliblue-cli-container
  elif [ "${OPTION,,}" == "disable" ]; then
    just disable-zeliblue-cli-container
  fi

[private]
enable-zeliblue-cli-container:
  #!/usr/bin/env bash
  mkdir -p ~/.config/containers/systemd
  cp /usr/share/zeliblue/quadlets/zeliblue-cli.container ~/.config/containers/systemd/zeliblue-cli.container

  systemctl --user daemon-reload

  podman image pull ghcr.io/zelikos/zeliblue-cli:latest

  systemctl --user start zeliblue-cli.service

  systemctl --user enable --now podman-auto-update.timer

  echo "Zeliblue CLI is now enabled."

[private]
disable-zeliblue-cli-container:
  #!/usr/bin/env bash

  systemctl --user stop zeliblue-cli.service
  rm ~/.config/containers/systemd/zeliblue-cli.container

  systemctl --user disable --now podman-auto-update.timer

  podman image rm ghcr.io/zelikos/zeliblue-cli:latest

  systemctl --user daemon-reload

  echo "Zeliblue CLI is now disabled."

# Install system flatpaks for rebasers
[private]
install-system-flatpaks:
    #!/usr/bin/bash
    IMAGE_INFO="/usr/share/zeliblue/image-info.json"
    BASE_IMAGE_NAME=$(jq -r '."base-image-name"' < $IMAGE_INFO)
    if [[ ${BASE_IMAGE_NAME} == 'silverblue' ]]; then
        FLATPAKS="installer/gnome-flatpaks"
    elif [[ ${BASE_IMAGE_NAME} == 'kinoite' ]]; then
        FLATPAKS="installer/plasma-flatpaks"
    fi
    # TODO: Fix URL if/when this is merged to main
    FLATPAK_LIST="$(curl https://raw.githubusercontent.com/zelikos/zeliblue/migrate-from-bluebuild/${FLATPAKS} | tr '\n' ' ')"
    flatpak --system -y install --or-update ${FLATPAK_LIST}
