#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

install -d /etc/systemd/system/nvzramconfig.service.d
install -m 755 "${SCRIPT_DIR}/jetson-zram-setup" /usr/local/sbin/jetson-zram-setup
install -m 644 "${SCRIPT_DIR}/jetson-zram-tuning.default" /etc/default/jetson-zram-tuning
install -m 644 "${SCRIPT_DIR}/nvzramconfig.override.conf" /etc/systemd/system/nvzramconfig.service.d/override.conf
install -m 644 "${SCRIPT_DIR}/99-jetson-memory-tuning.conf" /etc/sysctl.d/99-jetson-memory-tuning.conf

sysctl --system >/dev/null
systemctl daemon-reload
systemctl restart nvzramconfig.service

echo "Installed zram tuning and reconfigured nvzramconfig.service"
