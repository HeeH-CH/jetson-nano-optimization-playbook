#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

VERSION="8613"
SRC_DIR="/usr/src/backport-iwlwifi-${VERSION}"

modprobe -r iwlmvm iwlwifi mac80211 cfg80211 compat >/dev/null 2>&1 || true
dkms remove -m backport-iwlwifi -v "${VERSION}" --all >/dev/null 2>&1 || true
rm -rf "${SRC_DIR}"
depmod

echo "Removed custom backport-iwlwifi ${VERSION}"
echo "Reboot is recommended"
echo "Note: stock Jetson Nano iwlwifi may still be unusable for AC8265"
