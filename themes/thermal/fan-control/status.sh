#!/usr/bin/env bash
set -euo pipefail

echo "== systemd =="
systemctl is-enabled jetson-fan-control.service
systemctl is-active jetson-fan-control.service

echo
echo "== pwm =="
printf 'temp_control=%s\n' "$(cat /sys/devices/pwm-fan/temp_control)"
printf 'target_pwm=%s\n' "$(cat /sys/devices/pwm-fan/target_pwm)"
printf 'cur_pwm=%s\n' "$(cat /sys/devices/pwm-fan/cur_pwm)"

echo
echo "== thermal =="
for zone in /sys/class/thermal/thermal_zone*; do
  [[ -r "${zone}/type" && -r "${zone}/temp" ]] || continue
  type="$(<"${zone}/type")"
  case "${type}" in
    CPU-therm|GPU-therm|thermal-fan-est|AO-therm|PMIC-Die|PLL-therm)
      printf '%s=%s\n' "${type}" "$(<"${zone}/temp")"
      ;;
  esac
done

echo
echo "== recent logs =="
journalctl -u jetson-fan-control.service -n 10 --no-pager || true
