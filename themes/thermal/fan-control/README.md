# Fan Control

This module installs a small systemd service that controls the Jetson Nano PWM fan
from the highest of `CPU-therm` and `GPU-therm`.

## Why

The stock kernel-side behavior on this machine was present but weak and not clearly
documented in a reusable way. This module makes the behavior explicit and versioned.

## Behavior

- poll interval: `5` seconds
- hysteresis: `2C`
- kickstart when waking the fan from `0 PWM`
- step curve:
  - `0C -> 0`
  - `52C -> 120`
  - `57C -> 160`
  - `62C -> 200`
  - `67C -> 230`
  - `72C -> 255`

## Files

- `jetson-fan-control`: runtime script installed to `/usr/local/bin/jetson-fan-control`
- `jetson-fan-control.default`: config installed to `/etc/default/jetson-fan-control`
- `jetson-fan-control.service`: systemd unit installed to `/etc/systemd/system/jetson-fan-control.service`

## Install

```bash
cd themes/thermal/fan-control
sudo ./install.sh
```

## Verify

```bash
cd themes/thermal/fan-control
./status.sh
```

Expected state:

- `jetson-fan-control.service` is `enabled`
- `jetson-fan-control.service` is `active`
- `/sys/devices/pwm-fan/temp_control` is `0`

## Tune

Edit:

- `/etc/default/jetson-fan-control`

Then reload:

```bash
sudo systemctl restart jetson-fan-control
```

## Rollback

```bash
cd themes/thermal/fan-control
sudo ./rollback.sh
```
