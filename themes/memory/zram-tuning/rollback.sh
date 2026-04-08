#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

rm -f /usr/local/sbin/jetson-zram-setup
rm -f /etc/default/jetson-zram-tuning
rm -f /etc/sysctl.d/99-jetson-memory-tuning.conf
rm -f /etc/systemd/system/nvzramconfig.service.d/override.conf
rmdir --ignore-fail-on-non-empty /etc/systemd/system/nvzramconfig.service.d 2>/dev/null || true

systemctl daemon-reload
sysctl --system >/dev/null
systemctl restart nvzramconfig.service

echo "Restored vendor nvzramconfig behavior"
