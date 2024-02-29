# Include some of your custom scripts here!

# Install Homebrew
brew:
  #!/usr/bin/env bash
  if [[ ! -x "/var/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    echo "Brew Installation"
    echo "At the end of installation, the Brew installer will have a \"Next steps\" section."
    echo "In Zeliblue, the steps listed for adding homebrew to your PATH are not necessary,"
    echo "as they are already pre-configured. All you'll have to do is close and re-open the terminal!"
    echo "Please type in \"I understand\" to proceed with brew installation."
    read ACCEPT
    if [ "$ACCEPT" == "I understand" ]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
      echo "Capitalization matters when you type \"I understand\""
    fi
  else
    echo "Brew is already installed."
  fi

# Install a small selection of CLI utilties via brew
brew-utilities:
  #!/usr/bin/env bash
  if [[ ! -f $HOME/.local/share/zeliblue/Brewfile ]]
  then
    mkdir -p $HOME/.local/share/zeliblue
    cp /usr/share/zeliblue/Brewfile $HOME/.local/share/zeliblue/Brewfile
   fi
   brew bundle --file=$HOME/.local/share/zeliblue/Brewfile

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
  just setup-davincibox

  INSTALLER_FILE=$(readlink -e {{installer}})

  if [[ $(echo $INSTALLER_FILE) == "" ]]; then
    echo "Please re-run this command with the full path to the DaVinci Resolve's installer."
    echo "Example:"
    echo "just install-davinci /full/path/to/DaVinci_Resolve_18.5.1_Linux.run"
  else
    toolbox run --container davincibox setup-davinci $INSTALLER_FILE toolbox
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
