# Include some of your custom scripts here!

# Restore default apps installation
restore-default-apps:
    #!/usr/bin/bash
    IMAGE_INFO="/usr/share/zeliblue/image-info.json"
    IMAGE_FLAVOR=$(jq -r '."image-flavor"' < $IMAGE_INFO)
    FLATPAK_LIST="$(curl https://raw.githubusercontent.com/zelikos/zeliblue/main/iso_files/system-flatpaks.list | tr '\n' ' ')"
    flatpak --system -y install --or-update ${FLATPAK_LIST}
