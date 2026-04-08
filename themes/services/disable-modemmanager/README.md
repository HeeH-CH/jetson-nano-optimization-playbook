# Disable ModemManager

This module disables `ModemManager` on systems that do not use LTE/WWAN hardware.

## Why

On this machine:

- no LTE/WWAN workflow is in use
- `ModemManager` was enabled and running
- the daemon repeatedly probed unsupported devices
- it had a visible boot cost during the earlier service audit

## Install

```bash
cd themes/services/disable-modemmanager
sudo ./install.sh
```

## Verify

```bash
cd themes/services/disable-modemmanager
./status.sh
```

Expected state:

- `ModemManager.service` is masked
- `ModemManager.service` is inactive
- D-Bus activation does not bring it back automatically

## Rollback

```bash
cd themes/services/disable-modemmanager
sudo ./rollback.sh
```

Re-enable this if you later attach an LTE/WWAN modem.
