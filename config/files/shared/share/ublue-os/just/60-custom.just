!include /usr/share/ublue-os/just/100-bling.just

# Include some of your custom scripts here!

# Toggle between desktop/gamescope autologin
toggle-autologin:
  #!/usr/bin/env bash
  DESKTOP_AUTOLOGIN="/etc/zeliblue/desktop_autologin"
  if [[ -f $DESKTOP_AUTOLOGIN ]]; then
    sudo rm -f $DESKTOP_AUTOLOGIN
  else
    sudo touch $DESKTOP_AUTOLOGIN
  fi

# Refresh default flatpaks
refresh-default-flatpaks:
  pkexec rm /etc/ublue-os/system-flatpak-configured
  pkexec /usr/bin/system-flatpak-setup
  rm $HOME/.config/ublue-os/user-flatpak-configured
  /usr/bin/user-flatpak-setup

# Install Homebrew
brew:
  echo "Installing homebrew ..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Enable Homebrew in shells
brew-shell:
  #!/usr/bin/env bash
  set -euxo pipefail
  echo "Adding homebrew to shell configuration"
  touch $HOME/.zprofile
  touch $HOME/.bashrc
  if grep -q "linuxbrew" $HOME/.zprofile
  then
    echo "Brew configuration already present in .zprofile"
  else
    echo "Adding Brew configuration to .zprofile"
    echo 'eval "$(/var/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.zprofile
  fi
  if grep -q "linuxbrew" $HOME/.bashrc
  then
    echo "Brew configuration already present in .bashrc"
  else
    echo "Adding Brew configuration to .bashrc"
    echo 'eval "$(/var/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bashrc
  fi
  if [[ -f "$HOME/.config/fish/conf.d/00_homebrew.fish" ]]
  then
    echo "Brew configuration already present for fish"
  else
    mkdir -p "$HOME/.config/fish/conf.d/"
    echo 'eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $HOME/.config/fish/conf.d/00_homebrew.fish
  fi

# Install CLI utilties with Homebrew
brew-utilities:
  #!/usr/bin/env bash
  set -euxo pipefail
  if [[ ! -f $HOME/.local/share/zeliblue/Brewfile ]]
  then
    mkdir -p $HOME/.local/share/zeliblue
    cp /usr/share/zeliblue/Brewfile $HOME/.local/share/zeliblue/Brewfile
  fi
  brew bundle --file=$HOME/.local/share/zeliblue/Brewfile

# Install Homebrew, configure shells, and install Zeliblue utilities
setup-homebrew:
  #!/usr/bin/env bash
  just brew
  just brew-shell
  just brew-utilities

# Setup DaVinciBox container
setup-davincibox mode="":
  #!/usr/bin/env bash
  if [[ {{mode}} == "refresh" ]]; then
    distrobox stop -Y davincibox
    distrobox rm -Y davincibox
  fi
  podman image pull ghcr.io/zelikos/davincibox:latest
  distrobox create -i ghcr.io/zelikos/davincibox:latest -n davincibox

# Install DaVinci Resolve to DaVinciBox
install-davinci installer="":
  #!/usr/bin/env bash
  just setup-davincibox
  if [[ {{installer}} == "" ]]; then
    echo "Please re-run this command with the path to DaVinci Resolve's installer."
    echo "Example 1 (installer in current directory):"
    echo "just install-davinci DaVinci_Resolve_18.5.1_Linux.run"
    echo "Example 2 (installer in different directory):"
    echo "just install-davinci /path/to/DaVinci_Resolve_18.5.1_Linux.run"
  else
    distrobox enter davincibox -- setup-davinci {{installer}} distrobox
  fi

# Remove DaVinci Resolve and DaVinciBox
remove-davinci:
  #!/usr/bin/env bash
  distrobox enter davincibox -- add-davinci-launcher remove
  distrobox stop -Y davincibox
  distrobox rm -Y davincibox
