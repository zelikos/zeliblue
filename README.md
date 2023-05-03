# Starting point

This repository is based off of the [ublue-os/startingpoint](https://github.com/ublue-os/startingpoint), which eases the process of setting up your own container image based on top of Fedora Silverblue.

This specific repo, "zeliblue," is mainly intended for my own minor customizations to the default uBlue-ified Silverblue experience.

For more info, check out the [uBlue homepage](https://ublue.it/) and the [main uBlue repo](https://github.com/ublue-os/main/)

## Just

The `just` task runner is included in main for further customization after first boot.
You can copy the justfile from `/etc/justfile` to `~/.justfile` to get started. Once `just` supports [include directives](https://just.systems/man/en/chapter_52.html), you can just include the file in `/etc` into your own justfile, where you have the option of adding new tasks.
After that run the following commands:

- `just` - Show all tasks, more will be added in the future
- `just bios` - Reboot into the system bios (Useful for dualbooting)
- `just changelogs` - Show the changelogs of the pending update
- Set up distroboxes for the following images:
  - `just distrobox-boxkit`
  - `just distrobox-debian`
  - `just distrobox-opensuse`
  - `just distrobox-ubuntu`
- `just setup-flatpaks` - Install all of the flatpaks declared in recipe.yml
- `just setup-gaming` - Install Steam, Heroic Game Launcher, OBS Studio, Discord, Boatswain, Bottles, and ProtonUp-Qt. MangoHud is installed and enabled by default, hit right Shift-F12 to toggle
- `just nix-me-up` - Install Nix with dnkmmr69420's Nix Silverblue install script
- `just update` - Update rpm-ostree, flatpaks, and distroboxes in one command

Check the [just website](https://just.systems) for tips on modifying and adding your own recipes.

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/zelikos/zeliblue

If you're forking this repo, the uBlue website has [instructions](https://ublue.it/making-your-own/) for setting up signing properly.
