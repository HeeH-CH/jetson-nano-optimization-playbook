#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="/var/lib/jetson-performance-profile"
BACKUP_FILE="${BACKUP_DIR}/l4t_dfs.conf"

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

install -d "${BACKUP_DIR}"

if [[ ! -f "${BACKUP_FILE}" ]]; then
  jetson_clocks --store "${BACKUP_FILE}" >/dev/null
fi

install -m 755 "${SCRIPT_DIR}/jetson-performance-profile" /usr/local/sbin/jetson-performance-profile
install -m 644 "${SCRIPT_DIR}/jetson-performance-profile.default" /etc/default/jetson-performance-profile
install -m 644 "${SCRIPT_DIR}/jetson-performance-profile.service" /etc/systemd/system/jetson-performance-profile.service

systemctl daemon-reload
systemctl enable --now jetson-performance-profile.service
systemctl restart jetson-performance-profile.service

echo "Installed jetson-performance-profile.service"
