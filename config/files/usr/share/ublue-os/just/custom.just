!include /usr/share/ublue-os/just/bling.just

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

# Sign the current OCI OSTree Image (If unsigned)
sign-image:
  source /etc/default/zeliblue && \
  ublue-update --wait && \
  if grep -qvz "/var/${IMAGE_VENDOR}/image" <<< $(rpm-ostree status); then \
    rpm-ostree rebase ostree-image-signed:$(just --unstable _get-image); \
  else \
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/${IMAGE_VENDOR}/${IMAGE_NAME}:${FEDORA_MAJOR_VERSION}; \
  fi

_get-image:
  #!/usr/bin/env python
  from json import loads
  from subprocess import PIPE, run

  """Pull deployment status via rpm-ostree"""
  status = "rpm-ostree status --json"
  out = run(status, shell=True, stdout=PIPE).stdout

  """Parse current image"""
  deployments = loads(out)["deployments"][0]
  current_image = deployments["container-image-reference"].split(":", 1)

  """Dissect current image to form URL to latest image"""
  protocol = "docker://"
  url = current_image[1]

  """Add protocol if URL doesn't contain it"""
  if protocol not in url:
    url = protocol + url

  print(url)