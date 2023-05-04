# Starting point

This repository is based off of the [ublue-os/startingpoint](https://github.com/ublue-os/startingpoint), which eases the process of setting up your own container image based on top of Fedora Silverblue.

This specific repo, "zeliblue," is mainly intended for my own minor customizations to the default uBlue-ified Silverblue experience.

For more info, check out the [uBlue homepage](https://ublue.it/) and the [main uBlue repo](https://github.com/ublue-os/main/)

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/zelikos/zeliblue

If you're forking this repo, the uBlue website has [instructions](https://ublue.it/making-your-own/) for setting up signing properly.
