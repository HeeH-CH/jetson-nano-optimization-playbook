#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

systemctl disable --now kerneloops.service || true
systemctl stop kerneloops.service || true
systemctl mask kerneloops.service || true
systemctl stop kerneloops.service || true

echo "Disabled and masked kerneloops"
