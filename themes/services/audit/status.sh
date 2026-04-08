#!/usr/bin/env bash
set -euo pipefail

echo "== target services =="
systemctl list-unit-files --type=service | \
  rg 'accounts-daemon|avahi-daemon|bluetooth|ModemManager|packagekit|whoopsie|kerneloops|nvgetty|rpcbind|colord|fwupd|upower|udisks2'

echo
echo "== running target services =="
systemctl --type=service --state=running --no-pager | \
  rg 'accounts-daemon|avahi-daemon|bluetooth|ModemManager|packagekit|whoopsie|kerneloops|nvgetty|rpcbind|colord|fwupd|upower|udisks2'

echo
echo "== boot cost =="
systemd-analyze blame | \
  rg 'accounts-daemon|avahi-daemon|bluetooth|ModemManager|packagekit|whoopsie|kerneloops|nvgetty|rpcbind|colord|fwupd|upower|udisks2|apport' || true

echo
echo "== exposed ports =="
ss -lntup | rg ':(111|5353)\b|rpcbind|avahi' || true
