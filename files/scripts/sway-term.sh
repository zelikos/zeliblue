#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
sed -i 's/set $term foot/set $term alacritty/g' /etc/sway/config
