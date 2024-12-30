#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir -p /tmp/mesa-fix64/dri && \
    cp /usr/lib64/libgallium-*.so /tmp/mesa-fix64/ && \
    cp /usr/lib64/dri/kms_swrast_dri.so /tmp/mesa-fix64/dri/ && \
    cp /usr/lib64/dri/libdril_dri.so /tmp/mesa-fix64/dri/ && \
    cp /usr/lib64/dri/swrast_dri.so /tmp/mesa-fix64/dri/ && \
    cp /usr/lib64/dri/virtio_gpu_dri.so /tmp/mesa-fix64/dri/ && \
    mkdir -p /tmp/mesa-fix32/dri && \
    cp /usr/lib/libgallium-*.so /tmp/mesa-fix32/ && \
    cp /usr/lib/dri/kms_swrast_dri.so /tmp/mesa-fix32/dri/ && \
    cp /usr/lib/dri/libdril_dri.so /tmp/mesa-fix32/dri/ && \
    cp /usr/lib/dri/swrast_dri.so /tmp/mesa-fix32/dri/ && \
    cp /usr/lib/dri/virtio_gpu_dri.so /tmp/mesa-fix32/dri/ && \
    rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib \
        mesa-libxatracker \
        mesa-libglapi \
        mesa-dri-drivers \
        mesa-libgbm \
        mesa-libEGL \
        mesa-vulkan-drivers \
        mesa-libGL \
        pipewire \
        pipewire-alsa \
        pipewire-gstreamer \
        pipewire-jack-audio-connection-kit \
        pipewire-jack-audio-connection-kit-libs \
        pipewire-libs \
        pipewire-pulseaudio \
        pipewire-utils \
        pipewire-plugin-libcamera \
        bluez \
        bluez-obexd \
        bluez-cups \
        bluez-libs \
        xorg-x11-server-Xwayland && \
    rsync -a /tmp/mesa-fix64/ /usr/lib64/ && \
    rsync -a /tmp/mesa-fix32/ /usr/lib/ && \
    rm -rf /tmp/mesa-fix64 && \
    rm -rf /tmp/mesa-fix32
