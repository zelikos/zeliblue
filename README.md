# zeliblue

This repository is based off of the [ublue-os/startingpoint](https://github.com/ublue-os/startingpoint), which eases the process of setting up your own container image based on top of Fedora Silverblue. For more info, check out the [uBlue homepage](https://ublue.it/) and the [main uBlue repo](https://github.com/ublue-os/main/)

This specific repo, "zeliblue," features my own customizations to the default uBlue-ified Silverblue experience. It is mainly intended for my own use, but I am still experimenting with making it a general-purpose and user-friendly experience.

Notable changes include:

**yafti**
- Changes and expansion to the selection of apps
- User installation by default instead of upstream's systemwide; exceptions to this are for the Core GNOME Apps and System Apps

**dconf settings**
- Workspace navigation shortcuts are more akin to elementary OS's, to be more intuitive for horizontal workspaces
- Super+t to launch Console, also à la elementary OS
- Other miscellaneous tweaks

GNOME Console replaces GNOME Terminal as the default terminal; Black Box is available at first boot via yafti for more advanced needs.

## Installation

While I highly recommend looking into either the [main uBlue images](https://ublue.it/images/), or [making your own](https://ublue.it/making-your-own/), you can rebase onto zelibue if you really want to via the following:

> **Warning**
> This is an experimental feature and should not be used in production, try it in a VM for a while!

To rebase an existing Silverblue/Kinoite installation to the latest build:

```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/zelikos/zeliblue:latest
```

This repository builds date tags as well, so if you want to rebase to a particular day's build:

```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/zelikos/zeliblue:YYYYMMDD
```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/zelikos/zeliblue

If you're forking this repo, the uBlue website has [instructions](https://ublue.it/making-your-own/) for setting up signing properly.
