# 2026-04-09 Power Performance Profile

## Scope

- added a reproducible power/performance module
- pinned `nvpmodel` to `MAXN` mode `0`
- applied `jetson_clocks` through a boot-time systemd service
- stored a rollback backup of the prior DFS settings

## Commands

```bash
cd themes/power/performance-profile
sudo ./install.sh
```

## Validation

- `jetson-performance-profile.service` enabled
- `jetson-performance-profile.service` active
- `nvpmodel` reports `MAXN`
- `jetson_clocks --show` reflects fixed clocks
