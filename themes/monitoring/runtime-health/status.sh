#!/usr/bin/env bash
set -euo pipefail

temp_c() {
  local zone_type=$1
  local zone
  for zone in /sys/class/thermal/thermal_zone*; do
    [[ -r "${zone}/type" && -r "${zone}/temp" ]] || continue
    if [[ "$(<"${zone}/type")" == "${zone_type}" ]]; then
      printf '%s' "$(( $(<"${zone}/temp") / 1000 ))"
      return 0
    fi
  done
  printf 'n/a'
}

echo "== thermal =="
for zone in /sys/class/thermal/thermal_zone*; do
  [[ -r "${zone}/type" && -r "${zone}/temp" ]] || continue
  type="$(<"${zone}/type")"
  temp_raw="$(cat "${zone}/temp" 2>/dev/null || true)"
  [[ "${temp_raw}" =~ ^[0-9]+$ ]] || continue
  printf '%-16s %sC\n' "${type}" "$(( temp_raw / 1000 ))"
done

echo
echo "== fan =="
for file in temp_control target_pwm cur_pwm tach_enable rpm_measured; do
  if [[ -r "/sys/devices/pwm-fan/${file}" ]]; then
    printf '%-16s %s\n' "${file}" "$(<"/sys/devices/pwm-fan/${file}")"
  fi
done

echo
echo "== power =="
nvpmodel -q --verbose 2>/dev/null | sed -n '1,16p'
echo
sudo jetson_clocks --show 2>/dev/null | sed -n '1,20p'

echo
echo "== memory =="
free -h
echo
swapon --show

echo
echo "== storage =="
df -h /

echo
echo "== services =="
printf 'jetson-fan-control: %s\n' "$(systemctl is-active jetson-fan-control.service 2>/dev/null || true)"
printf 'jetson-performance-profile: %s\n' "$(systemctl is-active jetson-performance-profile.service 2>/dev/null || true)"
printf 'nvzramconfig: %s (%s)\n' "$(systemctl is-active nvzramconfig.service 2>/dev/null || true)" "$(systemctl is-enabled nvzramconfig.service 2>/dev/null || true)"

echo
echo "== tegrastats sample =="
{ timeout 2s tegrastats --interval 1000 2>/dev/null | head -n 1; } || true
