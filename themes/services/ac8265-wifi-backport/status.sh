#!/usr/bin/env bash
set -euo pipefail

echo "== dkms =="
dkms status | rg 'backport-iwlwifi' || true

echo
echo "== module path =="
modinfo -n iwlwifi 2>/dev/null || true

echo
echo "== live module version =="
if [[ -r /sys/module/iwlwifi/version ]]; then
  cat /sys/module/iwlwifi/version
else
  echo "iwlwifi not loaded"
fi

echo
echo "== loaded modules =="
lsmod | rg 'iwl|cfg80211|mac80211|compat' || true

echo
echo "== device state =="
nmcli device status || true

echo
echo "== wireless interfaces =="
iw dev 2>/dev/null || true

echo
echo "== wlan0 link =="
ip -details link show wlan0 2>/dev/null || true

echo
echo "== wifi scan =="
nmcli dev wifi list ifname wlan0 2>/dev/null | sed -n '1,20p' || true

echo
echo "== recent kernel log =="
dmesg | rg -i 'iwlwifi|iwlmvm|wlan0|cfg80211|firmware|Unknown symbol|failed' | tail -n 40 || true
