#!/usr/bin/env bash
set -euo pipefail

echo "== sysctl =="
sysctl vm.swappiness vm.vfs_cache_pressure vm.dirty_background_ratio vm.dirty_ratio vm.page-cluster

echo
echo "== zram =="
swapon --show
echo
zramctl

echo
echo "== nvzramconfig override =="
systemctl cat nvzramconfig.service
