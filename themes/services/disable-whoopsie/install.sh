#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

systemctl disable --now whoopsie.service || true
systemctl stop whoopsie.service || true
systemctl mask whoopsie.service || true
systemctl stop whoopsie.service || true

echo "Disabled and masked whoopsie"
