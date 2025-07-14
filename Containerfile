ARG OS_VERSION="42"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/silverblue"

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY /build_files /build_files
COPY /system_files /system_files
COPY /just /just

# # Base Image
FROM ${BASE_IMAGE}:${OS_VERSION} as zeliblue-base

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/build-base.sh && \
    ostree container commit


# Main Image
FROM zeliblue-base as zeliblue

# Zeliblue image info
ARG AKMODS_FLAVOR="coreos-stable"
ARG ZELIBLUE_PRETTY_NAME="Zeliblue"
ARG IMAGE_NAME="zeliblue"
ARG IMAGE_FLAVOR="main"
ARG ZELIBLUE_IMAGE_TAG="stable"
ARG IMAGE_VENDOR="zelikos"
ARG BASE_IMAGE_NAME="silverblue"

### MODIFICATIONS
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/build-main.sh && \
    ostree container commit


# Zeliblue Deck Image
FROM zeliblue as zeliblue-deck

# Deck image info
ARG AKMODS_FLAVOR="bazzite"
ARG ZELIBLUE_PRETTY_NAME="Zeliblue Deck"
ARG IMAGE_NAME="zeliblue-deck"
ARG IMAGE_FLAVOR="deck"
ARG ZELIBLUE_IMAGE_TAG="stable"
ARG IMAGE_VENDOR="zelikos"
ARG BASE_IMAGE_NAME="silverblue"

### MODIFICATIONS
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/build-deck.sh && \
    ostree container commit

### LINTING
## Verify final image and contents are correct.
# RUN bootc container lint
