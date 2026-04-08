# Disable Kerneloops

This module disables `kerneloops`, the service that collects and submits kernel
oops and crash signatures.

## What It Is

- `kerneloops` scans kernel logs for crash signatures
- it is mainly useful for crash reporting and debugging
- it is not required for normal Jetson runtime, networking, or camera use

## Why Disable It

On this machine:

- `kerneloops.service` was enabled and running
- it had visible boot cost during service audit
- kernel crash submission is not needed for the current usage pattern

## Install

```bash
cd themes/services/disable-kerneloops
sudo ./install.sh
```

## Verify

```bash
cd themes/services/disable-kerneloops
./status.sh
```

Expected state:

- `kerneloops.service` is `inactive`
- `kerneloops.service` is `masked`

## Rollback

```bash
cd themes/services/disable-kerneloops
sudo ./rollback.sh
```
