# zeliblue

Zeliblue is based off of [ublue-os/startingpoint](https://github.com/ublue-os/startingpoint), which eases the process of creating your own personalized image-based Fedora experience. For more detailed information, check out the [uBlue homepage](https://universal-blue.org/) and the [main uBlue repo](https://github.com/ublue-os/main/).

Zeliblue features the GNOME desktop as the flagship experience. Notable changes include:

- Workspace navigation shortcuts are adjusted, with the aim of being more intuitive for horizontal workspaces
- GNOME Console replaces GNOME Terminal as the default terminal, and can be launched with Super+t
- Flathub is set up in the background on first boot, both system-wide (flathub-system) and for per-user installs (flathub-user)
- GNOME Software defaults to installing apps from flathub-user
- Core system apps are installed to flathub-system after first boot
- System apps are selected based on the official [GNOME Core apps](https://apps.gnome.org/), with some substitutions and additions
- And more miscellaneous tweaks

There are also some additional flavors of Zeliblue:

Zeliblue Plasma (zeliblue-kinoite) uses the Plasma desktop environment instead of GNOME. It replaces multiple apps layered that are into the upstream image with Flatpak equivalents, as well as using `fish` as the default shell in Konsole.

Zeliblue Deck shares the same core as Zeliblue but with additional customizations to offer a SteamOS-like experience. It is functional but very experimental; it shouldn't *break* anything, but, if you're looking for a SteamOS alternative, I'd recommend using [uBlue's Bazzite](https://github.com/ublue-os/bazzite) instead.

## Installation

I recommend looking into either the [main uBlue images](https://universal-blue.org/images/) or [making your own](https://universal-blue.org/tinker/make-your-own/), but, if you want to, here's how you can use Zelibue on your system:

The recommended installation method is to use the latest ISO from [the Releases page](https://github.com/zelikos/zeliblue/releases/tag/auto-iso).

You can also rebase an existing Silverblue/Kinoite installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/zelikos/zeliblue:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```

After first boot, the first time that [ublue-update]() runs it will automatically rebase you onto the signed image.

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/zelikos/zeliblue
