setup-flatpaks:
  #!/usr/bin/env bash
  echo 'Installing flatpaks from the ublue recipe ...'
  flatpaks=$(yq -- '.firstboot.flatpaks[]' "/usr/share/ublue-os/recipe.yml")
  for pkg in $flatpaks; do \
      echo "Installing: ${pkg}" && \
      flatpak install --user --noninteractive flathub $pkg; \
  done

setup-gaming:
  #!/usr/bin/env bash
  echo 'Setting up gaming experience ... lock and load.'
  flatpak install -y --user \
  org.freedesktop.Platform.GStreamer.gstreamer-vaapi//22.08 \
  org.freedesktop.Platform.VulkanLayer.MangoHud//22.08 \
  org.freedesktop.Platform.VulkanLayer.OBSVkCapture//22.08 \
  org.freedesktop.Platform.VulkanLayer.vkBasalt//22.08 \
  com.obsproject.Studio \
  com.obsproject.Studio.Plugin.OBSVkCapture \
  com.obsproject.Studio.Plugin.Gstreamer \
  com.valvesoftware.Steam \
  com.valvesoftware.Steam.Utility.gamescope
  flatpak override --user --env=MANGOHUD=1 com.valvesoftware.Steam
  flatpak override --user --env=OBS_VKCAPTURE=1 com.valvesoftware.Steam

nix-me-up:
  #!/usr/bin/env bash
  echo 'Setting phasers to kill. Installing nix.'
  /usr/bin/ublue-nix-install
