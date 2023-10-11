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

assemble:
  distrobox assemble create --replace --file ~/dev/dotfiles/distrobox.ini

# Refresh default flatpaks
refresh-default-flatpaks:
  pkexec rm /etc/ublue-os/system-flatpak-configured
  pkexec /usr/bin/system-flatpak-setup
  rm $HOME/.config/ublue-os/user-flatpak-configured
  /usr/bin/user-flatpak-setup

# Install Homebrew
brew:
  echo "Installing homebrew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

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
