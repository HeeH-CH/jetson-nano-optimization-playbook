#!/usr/bin/env bash
set -euo pipefail

echo "== default target =="
systemctl get-default

echo
echo "== display managers =="
systemctl list-unit-files | rg 'gdm|lightdm|sddm' || true

echo
echo "== key services =="
printf 'ssh=%s\n' "$(systemctl is-active ssh.service 2>/dev/null || true)"
printf 'gdm=%s\n' "$(systemctl is-active gdm.service 2>/dev/null || true)"
printf 'graphical.target=%s\n' "$(systemctl is-enabled graphical.target 2>/dev/null || true)"

echo
echo "== memory =="
free -h
