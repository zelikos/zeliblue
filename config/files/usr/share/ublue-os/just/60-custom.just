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
  touch $HOME/.bash_profile
  mkdir -p $HOME/.config/fish
  touch $HOME/.config/fish/config.fish
  if grep -q "linuxbrew" $HOME/.zprofile
  then
    echo "Brew configuration already present in .zprofile"
  else
    echo "Adding Brew configuration to .zprofile"
    echo 'eval "$(/var/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.zprofile
  fi
  if grep -q "linuxbrew" $HOME/.bash_profile
  then
    echo "Brew configuration already present in .bash_profile"
  else
    echo "Adding Brew configuration to .bash_profile"
    echo 'eval "$(/var/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bash_profile
  fi
  if grep -q "linuxbrew" $HOME/.config/fish/config.fish
  then
    echo "Brew configuration already present in config.fish"
  else
    echo "Adding Brew configuration to config.fish"
    echo 'eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $HOME/.config/fish/config.fish
  fi
