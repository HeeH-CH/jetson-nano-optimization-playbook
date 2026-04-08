#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

install -d /etc/systemd/journald.conf.d
install -m 644 "${SCRIPT_DIR}/journald-jetson.conf" /etc/systemd/journald.conf.d/jetson-logging.conf
systemctl restart systemd-journald
journalctl --vacuum-size=64M >/dev/null || true

echo "Installed journald retention limits"
