#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

rm -f /etc/systemd/journald.conf.d/jetson-logging.conf
rmdir --ignore-fail-on-non-empty /etc/systemd/journald.conf.d 2>/dev/null || true
systemctl restart systemd-journald

echo "Removed journald retention limits"
