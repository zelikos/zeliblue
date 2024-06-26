#!/usrbin/env bash

set -ouex pipefail

# Test zeliblue gschema for errors. If there are no errors, proceed with compiling zeliblue gschema, which includes setting overrides. Also enable dconf-update service
mkdir -p /tmp/zeliblue-schema-test && \
find /usr/share/glib-2.0/schemas/ -type f ! -name "*.gschema.override" -exec cp {} /tmp/zeliblue-schema-test/ \; && \
cp /usr/share/glib-2.0/schemas/zz0-zeliblue.gschema.override /tmp/zeliblue-schema-test/ && \
echo "Running error test for zeliblue gschema override. Aborting if failed." && \
glib-compile-schemas --strict /tmp/zeliblue-schema-test && \
echo "Compiling gschema to include zeliblue setting overrides" && \
glib-compile-schemas /usr/share/glib-2.0/schemas &>/dev/null

systemctl enable dconf-update.service
