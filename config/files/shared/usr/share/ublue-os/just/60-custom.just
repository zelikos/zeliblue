# Include some of your custom scripts here!

# Install a small selection of CLI utilties via brew
brew-utilities:
  #!/usr/bin/bash
  source /usr/lib/ujust/ujust.sh

  OPTION=""
  echo "brew-utilities installs a handful of packages via brew,"
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
    echo "Utilities installed. Please restart your terminal."
  #elif [ "${OPTION,,}" == "no" ]; then
  #  just disable-zeliblue-cli
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
zeliblue-cli ACTION="prompt":
  #!/usr/bin/bash
  source /usr/lib/ujust/ujust.sh
  CURRENT_STATE="Disabled"
  if systemctl --quiet --user is-active zeliblue-cli.service; then
    CURRENT_STATE="Enabled"
  fi
  OPTION={{ ACTION }}
  if [ "$OPTION" == "prompt" ]; then
    echo "Zeliblue CLI is currently: ${bold}${CURRENT_STATE}${normal}"
    echo "Enable or Disable Zeliblue CLI?"
    OPTION=$(ugum choose Enable Disable)
  elif [ "$OPTION" == "help" ]; then
    echo "Usage: ujust zeliblue-cli <option>"
    echo "  <option>: Specify the quick option - 'enable' or 'disable'"
    echo "  Use 'enable' to Enable Zeliblue CLI."
    echo "  Use 'disable' to Disable Zeliblue CLI."
    exit 0
  fi
  if [ "${OPTION,,}" == "enable" ]; then
    just enable-zeliblue-cli
  elif [ "${OPTION,,}" == "disable" ]; then
    just disable-zeliblue-cli
  fi

[private]
enable-zeliblue-cli:
  #!/usr/bin/env bash
  mkdir -p ~/.config/containers/systemd
  cp /usr/share/zeliblue/quadlets/zeliblue-cli.container ~/.config/containers/systemd/zeliblue-cli.container

  systemctl --user daemon-reload

  podman image pull ghcr.io/zelikos/zeliblue-cli:latest

  systemctl --user start zeliblue-cli.service

  systemctl --user enable --now podman-auto-update.timer

  echo "Zeliblue CLI is now enabled."

[private]
disable-zeliblue-cli:
  #!/usr/bin/env bash

  systemctl --user stop zeliblue-cli.service
  rm ~/.config/containers/systemd/zeliblue-cli.container

  systemctl --user disable --now podman-auto-update.timer

  podman image rm ghcr.io/zelikos/zeliblue-cli:latest

  systemctl --user daemon-reload

  echo "Zeliblue CLI is now disabled."
