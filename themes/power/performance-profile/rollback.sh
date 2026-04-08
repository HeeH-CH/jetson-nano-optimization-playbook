#!/usr/bin/env bash
set -euo pipefail

BACKUP_FILE="/var/lib/jetson-performance-profile/l4t_dfs.conf"

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

systemctl disable --now jetson-performance-profile.service || true

if [[ -f "${BACKUP_FILE}" ]]; then
  jetson_clocks --restore "${BACKUP_FILE}" >/dev/null || true
fi

rm -f /etc/systemd/system/jetson-performance-profile.service
rm -f /etc/default/jetson-performance-profile
rm -f /usr/local/sbin/jetson-performance-profile
systemctl daemon-reload

echo "Removed performance profile service and restored saved clocks"
