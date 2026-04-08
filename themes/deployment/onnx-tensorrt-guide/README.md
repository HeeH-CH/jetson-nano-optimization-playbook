# ONNX And TensorRT Guide

This module is documentation-only.
It records the recommended deployment path for model inference on Jetson Nano.

## Recommended Path

For Jetson Nano, the default recommendation is:

1. Train or prepare the model in your framework.
2. Export the model to ONNX.
3. Build a TensorRT engine from ONNX.
4. Start with FP16.
5. Treat engine build as an offline build step, not something done in the hot path.

Short version:

```text
PyTorch -> ONNX -> TensorRT(FP16)
```

## Why This Path

Jetson Nano has limited CPU, memory, and I/O headroom.
Compared with running a general framework directly, TensorRT is usually the
highest-value optimization for inference deployment on Nano.

## Precision Guidance

- Prefer `FP16` first.
- Use `INT8` only if you have a calibration path and can verify accuracy.
- Do not assume `INT8` is a free upgrade.

## Engine Build Guidance

- Build engines offline when possible.
- Keep the runtime path focused on loading an already-built engine.
- Rebuild engines when:
  - model changes
  - TensorRT / JetPack stack changes
  - input shape assumptions change

## Framework Guidance

### PyTorch

- Prefer NVIDIA's Jetson-specific wheel or a Jetson container that matches your JetPack.
- Jetson Nano is effectively on the JetPack 4 line, so expect older CUDA/Python constraints.

### OpenCV

- The OpenCV packages that come with JetPack often do not include CUDA support.
- If OpenCV is on the critical path, only then consider a CUDA-enabled OpenCV build.
- On Nano, OpenCV source builds are heavy and memory-hungry.

## Camera Pipeline Guidance

- For CSI cameras, prefer `libargus` / `nvarguscamerasrc`.
- For USB cameras, use V4L2.
- Do not treat CSI cameras the same as generic USB webcams.

## Container Guidance

- Containers are useful for reproducible runtime packaging.
- On Nano, keep images small because SD-card space and I/O are limited.
- Avoid bloated dev images for final deployment.

## Storage Guidance

- Keep model files, engines, logs, and writable working data off microSD when possible.
- USB SSD is preferred over microSD for heavy write paths.

## Practical Rule Set

- If you need the model to run fast: prioritize TensorRT.
- If you need the setup to be repeatable: prioritize containers.
- If you need CSI camera support: prioritize Argus/GStreamer.
- If you need OpenCV CUDA: build it only after proving OpenCV is the bottleneck.

## Nano-Specific Caution

- JetPack 4 is now an end-of-life line.
- On Nano, prefer stable, version-matched components over chasing the newest framework versions.
- Expect more success from pinned versions and prebuilt Jetson-targeted artifacts than from generic upstream installs.

## Source Notes

This guide is based on:

- NVIDIA TensorRT documentation
- NVIDIA PyTorch-for-Jetson documentation
- NVIDIA Jetson camera software guidance
- NVIDIA Jetson container guidance
- Jetson Nano platform lifecycle constraints
