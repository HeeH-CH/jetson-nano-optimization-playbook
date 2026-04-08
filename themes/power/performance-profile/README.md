# Performance Profile

This module keeps the Jetson Nano in a reproducible sustained-performance setup.

## Behavior

- forces `nvpmodel` mode `0` (`MAXN`)
- applies `jetson_clocks` at boot
- does not touch fan settings
- stores a one-time backup of the previous clock state for rollback

## Why

On this machine, `nvpmodel` was already `MAXN`, but `jetson_clocks` was not
persisted. This module makes the power/clock setup explicit and reproducible.

## Caution

Use this only with stable power delivery and active cooling.

## Install

```bash
cd themes/power/performance-profile
sudo ./install.sh
```

## Verify

```bash
cd themes/power/performance-profile
./status.sh
```

Expected signs:

- `jetson-performance-profile.service` is `enabled`
- `jetson-performance-profile.service` is `active`
- `nvpmodel` reports `MAXN`
- `jetson_clocks --show` reports fixed max clocks and `FreqOverride=1`

## Tune

Edit:

- `/etc/default/jetson-performance-profile`

Then restart:

```bash
sudo systemctl restart jetson-performance-profile.service
```

## Rollback

```bash
cd themes/power/performance-profile
sudo ./rollback.sh
```
