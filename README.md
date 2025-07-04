# zeliblue

![Zeliblue Desktop](/repo_content/desktop1.webp?raw=true)

Zeliblue is a customized [Fedora Atomic Desktop](https://fedoraproject.org/atomic-desktops/) image, based on the [Universal Blue](http://universal-blue.org/) project, featuring the GNOME desktop as the flagship experience.

Notable changes from vanilla GNOME and Fedora Silverblue include:

- Ptyxis replaces GNOME Terminal as the default terminal, and can be launched with Super+t
- `fish` is set as the default shell in Ptyxis
- [Homebrew](https://brew.sh/) is enabled out of the box
- The `fish` shell is configured to integrate with certain [CLI utilities](#zeliblue-cli) for a more modern terminal experience
- Flathub is set up in the background on first boot, both system-wide (flathub-system) and for per-user installs (flathub-user)
- GNOME Software defaults to installing apps from flathub-user
- Core system apps are installed to flathub-system after first boot
- System apps are selected based on the official [GNOME Core apps](https://apps.gnome.org/), with some substitutions and additions
- And more miscellaneous tweaks

There was previously a Zeliblue Plasma (zeliblue-kinoite), but this image is now deprecated and no longer receives updates.

Zeliblue is made with [BlueBuild](https://blue-build.org/).

## Installation

For most users, I would recommend looking into either [Bluefin](https://projectbluefin.io/) or [Bazzite](https://bazzite.gg/), or, for tinkerers, I recommend [making your own](https://blue-build.org/learn/getting-started/). Both of the former two projects have many more contributors and a much larger community for support, whereas Zeliblue is run by one lone maintainer.

### ISOs

Pre-built ISOs are currently private and only for the GNOME edition of Zeliblue. These may be be made publicly available in the future.

For those that want to try Zeliblue in the meantime, or that want an ISO of other Zeliblue flavors, you can either rebase using the instructions in the next section, or you can build the ISO yourself. The recommended method is by using the [BlueBuild CLI utility](https://github.com/blue-build/cli?tab=readme-ov-file#installation) (requires v0.9.0 or later):

```
# Zeliblue
bluebuild generate-iso --variant gnome image ghcr.io/zelikos/zeliblue:stable

# Zeliblue Plasma
bluebuild generate-iso --variant kinoite image ghcr.io/zelikos/zeliblue-kinoite:stable
```

### Rebase

You *can* also rebase an existing Silverblue/Kinoite installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/zelikos/zeliblue:stable
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then, rebase onto the signed image:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/zelikos/zeliblue:stable
  systemctl reboot
  ```

If you instead want Zeliblue Plasma, replace `zeliblue` with `zeliblue-kinoite`, and, in the ISO action, `Silverblue` with `Kinoite`.


## `just` commands

On first boot of any Zeliblue flavor, a `justfile` is created in the user's home directory at `$HOME/.justfile`. The `justfile` gives access to Zeliblue's `just` commands; users can also add their own custom commands.

Commands provided by Zeliblue are documented below.

For more about `just`, see [the manual](https://just.systems/man/en/).

### zeliblue-cli

Installs a selection of brew packages as a "starter pack" for using Homebrew, focused on providing a more modern CLI experience:

```
atuin
bat
btop
chezmoi
eza
fastfetch
fd
gcc
git-delta
micro
ripgrep
tldr
starship
zoxide
```

The `fish` shell is configured by Zeliblue to utilize these packages if any are installed.

### setup-davincibox

Sets up a [davincibox](https://github.com/zelikos/davincibox) container with toolbox. Optionally takes "refresh" as a parameter to rebuild the container with the latest version of davincibox.

### install-davinci

Uses the `setup-davincibox` command, then installs DaVinci Resolve into davincibox, which also adds launchers to the app grid/menu for ease of use. DaVinci Resolve must be downloaded from [their website](https://www.blackmagicdesign.com/products/davinciresolve), and the installer passed to the command as a parameter.

Example: `just install-davinci /full/path/to/DaVinci_Resolve_18.5.1_Linux.run`

### remove-davinci

Removes DaVinci Resolve app launchers and davincibox container.

### zeliblue-cli-container

Enable or disable an auto-updating `zeliblue` distrobox intended as an alternative CLI experience, based on Fedora Toolbox. The `zeliblue-cli` image is derived from [Universal Blue's fedora-toolbox](https://github.com/ublue-os/toolboxes).

## Scope

Zeliblue is created with the goal of providing an opiniated experience that emphasizes ease of use for non tech savvy users (i.e. "average" users), while also providing extra options for those with more computer experience. Those extra options are to be provided in a way that doesn't distract the average user, primarily via `just` commands.

In other words, Zeliblue is made to meet [my](https://github.com/zelikos) needs while also being something I would comfortably recommend to friends and family.

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/zelikos/zeliblue
