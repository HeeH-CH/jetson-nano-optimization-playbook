# 2026-04-09 Memory And Storage Tuning

## Scope

- replaced stock zram startup with a local override
- increased total zram from about `2.0G` to `3.0G`
- applied VM tunables better aligned with zram-backed swap
- capped journald retention for flash-friendly log growth

## Commands

```bash
cd themes/memory/zram-tuning
sudo ./install.sh

cd ../..
cd themes/storage/log-retention
sudo ./install.sh
```

## Validation

- `vm.swappiness=100`
- `vm.vfs_cache_pressure=50`
- `vm.dirty_background_ratio=5`
- `vm.dirty_ratio=15`
- `vm.page-cluster=0`
- `/dev/zram0..3` each at `768M`, total `3.0G`
- journald override installed at `/etc/systemd/journald.conf.d/jetson-logging.conf`
