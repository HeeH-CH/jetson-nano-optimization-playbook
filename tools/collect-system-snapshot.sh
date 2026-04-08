#!/usr/bin/env bash
set -euo pipefail

echo "== board =="
cat /proc/device-tree/model 2>/dev/null | tr -d '\0'

echo
echo "== l4t =="
cat /etc/nv_tegra_release

echo
echo "== kernel =="
uname -a

echo
echo "== power mode =="
nvpmodel -q --verbose 2>/dev/null | sed -n '1,12p'

echo
echo "== memory =="
free -h

echo
echo "== storage =="
df -h /

echo
echo "== thermal =="
for zone in /sys/class/thermal/thermal_zone*; do
  [[ -r "${zone}/type" && -r "${zone}/temp" ]] || continue
  printf '%s=%s\n' "$(<"${zone}/type")" "$(<"${zone}/temp")"
done

echo
echo "== fan =="
for file in temp_control target_pwm cur_pwm rpm_measured tach_enable; do
  if [[ -r "/sys/devices/pwm-fan/${file}" ]]; then
    printf '%s=%s\n' "${file}" "$(<"/sys/devices/pwm-fan/${file}")"
  fi
done
