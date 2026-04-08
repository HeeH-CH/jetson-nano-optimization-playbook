#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

systemctl unmask whoopsie.service || true
systemctl enable --now whoopsie.service

echo "Re-enabled whoopsie"
