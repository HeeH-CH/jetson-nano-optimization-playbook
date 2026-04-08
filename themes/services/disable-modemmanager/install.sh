#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

systemctl disable --now ModemManager.service || true
systemctl disable dbus-org.freedesktop.ModemManager1.service || true
systemctl stop ModemManager.service || true
systemctl mask ModemManager.service || true

echo "Disabled and masked ModemManager"
