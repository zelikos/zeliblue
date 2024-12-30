#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

rsync -a /tmp/mesa-fix64/ /usr/lib64/
rsync -a /tmp/mesa-fix32/ /usr/lib/
rm -rf /tmp/mesa-fix64
rm -rf /tmp/mesa-fix32
