#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

systemctl disable --now jetson-fan-control.service || true
rm -f /etc/systemd/system/jetson-fan-control.service
rm -f /etc/default/jetson-fan-control
rm -f /usr/local/bin/jetson-fan-control
systemctl daemon-reload

if [[ -w /sys/devices/pwm-fan/temp_control ]]; then
  echo 1 > /sys/devices/pwm-fan/temp_control || true
fi

echo "Removed jetson-fan-control and restored kernel temp control"
