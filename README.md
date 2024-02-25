# zeliblue

![Zeliblue Desktop](/repo_content/desktop1.webp?raw=true)

Zeliblue is based off of [BlueBuild](https://blue-build.org/).

Zeliblue features the GNOME desktop as the flagship experience. Notable changes include:

- Workspace navigation shortcuts are adjusted, with the aim of being more intuitive for horizontal workspaces
- GNOME Console replaces GNOME Terminal as the default terminal, and can be launched with Super+t
- Flathub is set up in the background on first boot, both system-wide (flathub-system) and for per-user installs (flathub-user)
- GNOME Software defaults to installing apps from flathub-user
- Core system apps are installed to flathub-system after first boot
- System apps are selected based on the official [GNOME Core apps](https://apps.gnome.org/), with some substitutions and additions
- And more miscellaneous tweaks

There are also some additional flavors of Zeliblue:

Zeliblue GTS, which is nearly identical to the main image. The difference is that GTS follows the latest version of Fedora, minus one. In other words, when Zeliblue is on Fedora 39, GTS is on Fedora 38. While the main image should work well for most users, GTS is provided for those that desire extra stability.

Zeliblue Plasma (zeliblue-kinoite) uses the Plasma desktop environment instead of GNOME. It replaces multiple apps that are layered into the upstream image with Flatpak equivalents, as well as using `fish` as the default shell in Konsole.

## Installation

For most users, I would recommend looking into either [Bluefin](https://projectbluefin.io/) or [Bazzite](https://bazzite.gg/), or, for tinkerers, I recommend [making your own](https://blue-build.org/learn/getting-started/). Both of the former two projects have many more contributors and a much larger community for support, whereas Zeliblue is run by one lone maintainer.

With that being said, for those that do still want to give Zeliblue a try, the recommended installation method is to use the latest ISO from [the Releases page](https://github.com/zelikos/zeliblue/releases/tag/auto-iso).

You can also rebase an existing Silverblue/Kinoite installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/zelikos/zeliblue:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```

After first boot, the first of the system updater will automatically rebase you onto the signed image.

## `just` commands

On first boot of any Zeliblue flavor, a `justfile` is created in the user's home directory at `$HOME/.justfile`. The `justfile` gives access to Zeliblue's `just` commands; users can also add their own custom commands.

Commands provided by Zeliblue are documented below.

For more about `just`, see [the manual](https://just.systems/man/en/).

### setup-davincibox

Sets up a [davincibox](https://github.com/zelikos/davincibox) container with toolbox. Optionally takes "refresh" as a parameter to rebuild the container with the latest version of davincibox.

### install-davinci

Uses the `setup-davincibox` command, then installs DaVinci Resolve into davincibox, which also adds launchers to the app grid/menu for ease of use. DaVinci Resolve must be downloaded from [their website](https://www.blackmagicdesign.com/products/davinciresolve), and the installer passed to the command as a parameter.

Example: `just install-davinci /full/path/to/DaVinci_Resolve_18.5.1_Linux.run`

### remove-davinci

Removes DaVinci Resolve app launchers and davincibox container.

### zeliblue-cli

Enable or disable an auto-updating `zeliblue` distrobox intended as the default CLI experience. The `zeliblue-cli` image is derived from [Universal Blue's fedora-toolbox](https://github.com/ublue-os/toolboxes).

## Scope

Zeliblue is created with the goal of providing an opiniated experience that emphasizes ease of use for non tech savvy users (i.e. "average" users), while also providing extra options for those with more computer experience. Those extra options are to be provided in a way that doesn't distract the average user, primarily via `just` commands.

In other words, Zeliblue is made to meet [my](https://github.com/zelikos) needs while also being something I would comfortably recommend to friends and family.

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/zelikos/zeliblue
