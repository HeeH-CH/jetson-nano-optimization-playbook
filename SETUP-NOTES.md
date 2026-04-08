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
