# Setup Notes

This file is for early machine-specific setup facts that are easy to forget.

## Node.js On Stock Jetson Nano OS

- On the stock OS image, use:

```bash
nvm use 16
```

- Practical rule: stay on Node.js `16` unless you have explicitly upgraded the
  base userspace or validated a newer runtime on this board.

## Why

Observed behavior on the stock Jetson Nano OS:

- newer Node.js versions may fail to install or fail to run
- the likely cause is the older `glibc` level in the stock userspace

This note should be treated as an environment compatibility constraint, not as
an application bug.

## IMX219 Probe Note

If a single CSI IMX219 camera is connected, boot logs may still show:

```text
imx219 8-0010: board setup failed
```

What this means on this machine:

- `imx219 7-0010` is the working sensor path
- `imx219 8-0010` is an extra probe attempt that does not answer on I2C
- this does not block normal camera use as long as the active sensor still binds

Observed healthy signs:

- `/dev/video0` exists
- the device identifies as `vi-output, imx219 7-0010`
- `nvarguscamerasrc` capture succeeds

Treat the message as informational unless the active sensor also fails or camera
capture stops working.
