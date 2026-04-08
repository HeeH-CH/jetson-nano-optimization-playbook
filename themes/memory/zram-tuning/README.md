# ZRAM Tuning

This module replaces the stock NVIDIA zram setup with a reproducible local script
and applies VM tunables that are more suitable for a small-RAM Jetson Nano.

## Why

Stock behavior on this machine:

- zram total size: about `2.0G`
- per-device algorithm options: `lzo`, `deflate`
- default VM tunables:
  - `swappiness=60`
  - `vfs_cache_pressure=100`
  - `dirty_background_ratio=10`
  - `dirty_ratio=20`
  - `page-cluster=3`

For build-heavy or desktop workloads on Jetson Nano, a larger zram pool and
more zram-friendly VM parameters reduce low-memory stalls and lower write bursts
to flash storage.

## Applied Settings

- total zram size: `3072 MB`
- algorithm: `lzo`
- priority: `100`
- `vm.swappiness=100`
- `vm.vfs_cache_pressure=50`
- `vm.dirty_background_ratio=5`
- `vm.dirty_ratio=15`
- `vm.page-cluster=0`

## Install

```bash
cd themes/memory/zram-tuning
sudo ./install.sh
```

## Verify

```bash
cd themes/memory/zram-tuning
./status.sh
```

## Rollback

```bash
cd themes/memory/zram-tuning
sudo ./rollback.sh
```
