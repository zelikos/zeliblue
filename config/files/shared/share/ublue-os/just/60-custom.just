# import '100-bling.just'

# Include some of your custom scripts here!

# Setup DaVinciBox container
setup-davincibox mode="":
  #!/usr/bin/env bash
  if [[ $(echo {{mode}}) == "refresh" ]]; then
    distrobox stop -Y davincibox
    distrobox rm -Y davincibox
  fi
  podman image pull ghcr.io/zelikos/davincibox:latest
  distrobox create -i ghcr.io/zelikos/davincibox:latest -n davincibox

# Install DaVinci Resolve to DaVinciBox
install-davinci installer="":
  #!/usr/bin/env bash
  just setup-davincibox
  if [[ $(echo {{installer}}) == "" ]]; then
    echo "Please re-run this command with the path to DaVinci Resolve's installer."
    echo "The full path is needed, even if in the current directory."
    echo "Example:"
    echo "just install-davinci /full/path/to/DaVinci_Resolve_18.5.1_Linux.run"
  else
    distrobox enter davincibox -- setup-davinci {{installer}} distrobox
  fi

# Remove DaVinci Resolve and DaVinciBox
remove-davinci:
  #!/usr/bin/env bash
  distrobox enter davincibox -- add-davinci-launcher remove
  distrobox stop -Y davincibox
  distrobox rm -Y davincibox

# Toggle Zeliblue-CLI
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

[private]
disable-zeliblue-cli:
  #!/usr/bin/env bash
  rm ~/.config/containers/systemd/zeliblue-cli.container

  systemctl --user stop zeliblue-cli.service
  systemctl --user disable --now podman-auto-update.timer

  podman image rm ghcr.io/zelikos/zeliblue-cli:latest

  systemctl --user daemon-reload
