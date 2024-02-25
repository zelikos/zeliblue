#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

if grep -q "silverblue" <<< "${BASE_IMAGE}"
then
  sed -i '/^PRETTY_NAME/s/Silverblue/Zeliblue/' /usr/lib/os-release
elif grep -q "kinoite" <<< "${BASE_IMAGE}"
then
  sed -i '/^PRETTY_NAME/s/Kinoite/Zeliblue Plasma/' /usr/lib/os-release
fi