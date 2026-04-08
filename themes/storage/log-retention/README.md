# Log Retention

This module caps systemd journal growth to protect flash storage from
unbounded log accumulation.

## Applied Settings

- `SystemMaxUse=64M`
- `RuntimeMaxUse=32M`
- `SystemMaxFileSize=16M`
- `RuntimeMaxFileSize=8M`

## Install

```bash
cd themes/storage/log-retention
sudo ./install.sh
```

## Verify

```bash
cd themes/storage/log-retention
./status.sh
```

## Rollback

```bash
cd themes/storage/log-retention
sudo ./rollback.sh
```
