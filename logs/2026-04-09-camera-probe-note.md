# 2026-04-09 Camera Probe Note

## Scope

- recorded a camera-specific note without changing the system

## Finding

The kernel logs show:

- `imx219 7-0010` binds successfully
- `imx219 8-0010` fails probe with `board setup failed`

On this machine that is not currently treated as a fault because:

- `/dev/video0` exists
- the active node identifies as `vi-output, imx219 7-0010`
- `nvarguscamerasrc` test capture succeeds

## Interpretation

This looks like a second sensor probe path that is empty, while the actual
single connected IMX219 works normally.
