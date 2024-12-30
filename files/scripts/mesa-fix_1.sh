#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

mkdir -p /tmp/mesa-fix64/dri
cp /usr/lib64/libgallium-*.so /tmp/mesa-fix64/
cp /usr/lib64/dri/kms_swrast_dri.so /tmp/mesa-fix64/dri/
cp /usr/lib64/dri/libdril_dri.so /tmp/mesa-fix64/dri/
cp /usr/lib64/dri/swrast_dri.so /tmp/mesa-fix64/dri/
cp /usr/lib64/dri/virtio_gpu_dri.so /tmp/mesa-fix64/dri/
mkdir -p /tmp/mesa-fix32/dri
cp /usr/lib/libgallium-*.so /tmp/mesa-fix32/
cp /usr/lib/dri/kms_swrast_dri.so /tmp/mesa-fix32/dri/
cp /usr/lib/dri/libdril_dri.so /tmp/mesa-fix32/dri/
cp /usr/lib/dri/swrast_dri.so /tmp/mesa-fix32/dri/
cp /usr/lib/dri/virtio_gpu_dri.so /tmp/mesa-fix32/dri/
