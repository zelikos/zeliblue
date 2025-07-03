# vim: set ft=make :

alias upgrade := update

# Upgrade system, apps, and Homebrew packages
update:
    #!/usr/bin/bash
    /usr/bin/pkexec /usr/bin/zeliblue-update

alias auto-update := toggle-updates

switch BRANCH="prompt":
    #!/usr/bin/bash

    switch_channel () {
      /usr/bin/pkexec /usr/bin/zeliblue-update --rebase $1
    }

    OPTION={{ BRANCH }}
    case $OPTION in
      stable|testing)
        echo "Switching to $OPTION channel..."
        switch_channel $OPTION
        exit 0
        ;;
      prompt)
        channel=$(cut -d ":" -f4 <<< "$(rpm-ostree status --booted | grep -m 1 zeliblue)")
        echo "Current release channel: $channel"
        echo "Select release channel to switch to:"
        channel=$(ugum choose Stable Testing Cancel)
        if [[ "${channel,,}" == "cancel" ]]; then
          exit 0
        else
          switch_channel "${channel,,}"
        fi
        exit 0
        ;;
      *)
        echo "Branch $OPTION not recognized."
        echo "Syntax: ujust switch <stable|testing>"
    esac

# Turn automatic updates on or off
toggle-updates ACTION="prompt":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    CURRENT_STATE="Disabled"
    if systemctl is-enabled rpm-ostreed-automatic.timer | grep -q enabled; then
      CURRENT_STATE="Enabled"
    fi
    OPTION={{ ACTION }}
    if [ "$OPTION" == "prompt" ]; then
      echo "Automatic updates are currently: ${bold}${CURRENT_STATE}${normal}"
      echo "Enable or Disable automatic updates?"
      OPTION=$(ugum choose Enable Disable)
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: ujust toggle-updates <option>"
      echo "  <option>: Specify the quick option - 'enable' or 'disable'"
      echo "  Use 'enable' to Enable automatic updates."
      echo "  Use 'disable' to Disable automatic updates."
      exit 0
    fi
    if [ "${OPTION,,}" == "enable" ]; then
      sudo systemctl enable rpm-ostreed-automatic.timer
    elif [ "${OPTION,,}" == "disable" ]; then
      sudo systemctl disable rpm-ostreed-automatic.timer
    fi

alias changelog := changelogs

# Show the changelog
changelogs:
  rpm-ostree db diff --changelogs
