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

# Initialize Zeliblue CLI environment
enable-zeliblue-cli:
  #!/usr/bin/env bash
  mkdir -p ~/.config/containers/systemd
  cp /usr/share/zeliblue/quadlets/zeliblue-cli.container ~/.config/containers/systemd/zeliblue-cli.container

  systemctl --user daemon-reload

  systemctl --user enable --now podman-auto-update.timer
  systemctl --user start zeliblue-cli.service
