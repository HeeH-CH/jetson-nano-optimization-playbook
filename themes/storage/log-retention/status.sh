#!/usr/bin/env bash
set -euo pipefail

echo "== journald config =="
if [[ -f /etc/systemd/journald.conf.d/jetson-logging.conf ]]; then
  cat /etc/systemd/journald.conf.d/jetson-logging.conf
else
  echo "override file not installed"
fi

echo
echo "== disk usage =="
journalctl --disk-usage
