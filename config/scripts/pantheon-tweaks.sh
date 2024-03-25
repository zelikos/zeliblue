#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Hide LightDM settings app, since trying to remove it results in deepin desktop stuff being pulled in...for some reason
echo "NoDisplay=true" >> /usr/share/applications/lightdm-settings.desktop