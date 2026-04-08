#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

install -m 755 "${SCRIPT_DIR}/jetson-fan-control" /usr/local/bin/jetson-fan-control
install -m 644 "${SCRIPT_DIR}/jetson-fan-control.default" /etc/default/jetson-fan-control
install -m 644 "${SCRIPT_DIR}/jetson-fan-control.service" /etc/systemd/system/jetson-fan-control.service

systemctl daemon-reload
systemctl enable --now jetson-fan-control.service
systemctl restart jetson-fan-control.service

echo "Installed and started jetson-fan-control.service"
