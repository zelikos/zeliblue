# vim: set ft=make :

alias upgrade := update

# Upgrade system, containers, and brew
update:
  #!/usr/bin/bash
  /usr/bin/topgrade --config /usr/share/ublue-update/topgrade-system.toml
  /usr/bin/topgrade --config /usr/share/ublue-update/topgrade-user.toml --keep

alias changelog := changelogs

# Show the changelog
changelogs:
  rpm-ostree db diff --changelogs
