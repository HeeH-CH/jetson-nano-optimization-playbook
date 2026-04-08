#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

systemctl unmask kerneloops.service || true
systemctl enable --now kerneloops.service

echo "Re-enabled kerneloops"
