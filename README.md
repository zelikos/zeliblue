# zeliblue

This repository is based off of the [ublue-os/startingpoint](https://github.com/ublue-os/startingpoint), which eases the process of setting up your own container image based on top of Fedora Silverblue, Kinoite, or other OSTree-based images. For more info, check out the [uBlue homepage](https://universal-blue.org/) and the [main uBlue repo](https://github.com/ublue-os/main/)

This specific repo, "zeliblue," features my own customizations to the default uBlue-ified Silverblue experience. It is mainly intended for my own use, but I am still working on making it a general-purpose and user-friendly experience.

Notable changes include:

- Workspace navigation shortcuts are more akin to elementary OS's, to be more intuitive for horizontal workspaces
- GNOME Console replaces GNOME Terminal as the default terminal, and can be launched with Super+t à la elementary OS
- Flathub is set up in the background on first boot (adapted from [Bazzite](https://github.com/ublue-os/bazzite)), both system-wide (flathub-system) and for per-user installs (flathub-user)
- GNOME Software defaults to installing apps from flathub-user
- Core system apps are installed to flathub-system after first boot
- System apps are selected based on the official [GNOME Core apps](https://apps.gnome.org/), with some substitutions and additions
- And more miscellaneous tweaks

Zeliblue also features a Kinoite spin and a SteamOS/Steam Deck flavor.

Zeliblue Plasma (zeliblue-kinoite) replaces multiple apps layered into the upstream image with Flatpak equivalents, as well as using `fish` as the default shell in Konsole.

The SteamOS variant, zeliblue-deck, is functional but very experimental; it shouldn't *break* anything, but I'd recommend using [uBlue's Bazzite](https://github.com/ublue-os/bazzite) instead, if you're looking for a SteamOS alternative.

## Installation

While I highly recommend looking into either the [main uBlue images](https://universal-blue.org/images/), or [making your own](https://universal-blue.org/tinker/make-your-own/), you can rebase onto zelibue if you really want to via the following:

> **Warning**
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable) and should not be used in production, try it in a VM for a while!

To rebase an existing Silverblue/Kinoite installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/zelikos/zeliblue:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Upon first boot into Zeliblue, yafti will pop up and prompt you to sign the image. You can do so there, or follow the steps below.

- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/zelikos/zeliblue:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

This repository builds date tags as well, so if you want to rebase to a particular day's build:

```
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/zelikos/zeliblue:YYYYMMDD
```

This repository by default also supports signing.

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/zelikos/zeliblue

If you're forking this repo, the uBlue website has [instructions](https://universal-blue.org/tinker/make-your-own/) for setting up signing properly.
