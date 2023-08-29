# zeliblue

This repository is based off of the [ublue-os/startingpoint](https://github.com/ublue-os/startingpoint), which eases the process of setting up your own container image based on top of Fedora Silverblue, Kinoite, or other OSTree-based images. For more info, check out the [uBlue homepage](https://universal-blue.org/) and the [main uBlue repo](https://github.com/ublue-os/main/)

This specific repo, "zeliblue," features my own customizations to the default uBlue-ified Silverblue experience. It is mainly intended for my own use, but I am still working on making it a general-purpose and user-friendly experience. I'm also experimenting with a Kinoite version.

Notable changes include:

**yafti**
- App selection is greatly reduced to focus more on core GNOME apps and related extra utilities, inspired by [Beyond](https://github.com/ublue-os/beyond)

**dconf settings**
- Workspace navigation shortcuts are more akin to elementary OS's, to be more intuitive for horizontal workspaces
- Super+t to launch Console, also à la elementary OS
- Other miscellaneous tweaks

GNOME Console replaces GNOME Terminal as the default terminal; Black Box is available at first boot via yafti for more advanced needs.

## Installation

While I highly recommend looking into either the [main uBlue images](https://universal-blue.org/images/), or [making your own](https://universal-blue.org/tinker/make-your-own/), you can rebase onto zelibue if you really want to via the following:

> **Warning**
> This is an experimental feature and should not be used in production, try it in a VM for a while!

To rebase an existing Silverblue/Kinoite installation to the latest build:

- First rebase to the image unsigned, to get the proper signing keys and policies installed:
  ```
  sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/zelikos/zeliblue:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/zelikos/zeliblue:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```


This repository builds date tags as well, so if you want to rebase to a particular day's build:

```
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/zelikos/zeliblue:YYYYMMDD
```

This repository by default also supports signing 

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/zelikos/zeliblue

If you're forking this repo, the uBlue website has [instructions](https://universal-blue.org/tinker/make-your-own/) for setting up signing properly.
