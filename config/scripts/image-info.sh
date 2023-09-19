#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
IMAGE_VENDOR=zelikos
mkdir -p /usr/etc/default
echo -e "IMAGE_NAME=${IMAGE_NAME}\nIMAGE_VENDOR=${IMAGE_VENDOR}\nBASE_IMAGE_NAME=${BASE_IMAGE}\nFEDORA_MAJOR_VERSION=${OS_VERSION}" >> /usr/etc/default/zeliblue

sed -i '/^PRETTY_NAME/s/Silverblue/Zeliblue/' /usr/lib/os-release
