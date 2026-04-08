#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

systemctl unmask ModemManager.service || true
systemctl enable --now ModemManager.service

echo "Re-enabled ModemManager"
