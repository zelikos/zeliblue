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
