#!/usr/bin/env bash
set -euo pipefail

echo "== systemd =="
systemctl is-enabled jetson-performance-profile.service
systemctl is-active jetson-performance-profile.service

echo
echo "== nvpmodel =="
nvpmodel -q --verbose 2>/dev/null | sed -n '1,20p'

echo
echo "== jetson_clocks =="
sudo jetson_clocks --show 2>/dev/null | sed -n '1,120p'
