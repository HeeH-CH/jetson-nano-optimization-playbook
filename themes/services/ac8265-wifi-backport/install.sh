#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Run as root" >&2
  exit 1
fi

VERSION="8613"
TAG="applied/8613-0ubuntu1"
REPO_URL="https://git.launchpad.net/ubuntu/+source/backport-iwlwifi-dkms"
SRC_DIR="/usr/src/backport-iwlwifi-${VERSION}"
WORK_DIR="$(mktemp -d /tmp/backport-iwlwifi-${VERSION}.XXXXXX)"

cleanup() {
  rm -rf "${WORK_DIR}"
}

trap cleanup EXIT

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

for cmd in git dkms perl sed depmod modprobe; do
  require_cmd "${cmd}"
done

echo "Cloning source tag ${TAG}"
git clone --quiet "${REPO_URL}" "${WORK_DIR}/repo"

rm -rf "${SRC_DIR}"
mkdir -p "${SRC_DIR}"
git -C "${WORK_DIR}/repo" archive --format=tar "${TAG}" | tar -C "${SRC_DIR}" -xf -

echo "Applying Jetson Nano compatibility patches"
perl -0pi -e 's/#if LINUX_VERSION_IS_GEQ\(4,13,0\)\n#include_next <linux\/build_bug.h>\n#else \/\* LINUX_VERSION_IS_GEQ\(4,13,0\) \*\/\n#include <linux\/bug.h>\n#endif \/\* LINUX_VERSION_IS_GEQ\(4,13,0\) \*\/\n/#include_next <linux\/build_bug.h>\n/s' \
  "${SRC_DIR}/backport-include/linux/build_bug.h"

sed -i 's/LINUX_VERSION_IS_LESS(4,11,0)/LINUX_VERSION_IS_LESS(4,9,0)/' \
  "${SRC_DIR}/backport-include/linux/random.h"

sed -i 's/^BPAUTO_SYSTEM_DATA_VERIFICATION=$/BPAUTO_SYSTEM_DATA_VERIFICATION=n/' \
  "${SRC_DIR}/local-symbols"
sed -i 's/^BPAUTO_BUILD_SYSTEM_DATA_VERIFICATION=$/BPAUTO_BUILD_SYSTEM_DATA_VERIFICATION=n/' \
  "${SRC_DIR}/local-symbols"
sed -i 's/^BPAUTO_PKCS7=$/BPAUTO_PKCS7=n/' \
  "${SRC_DIR}/local-symbols"

sed -i '/select BPAUTO_SYSTEM_DATA_VERIFICATION/d' \
  "${SRC_DIR}/net/wireless/Kconfig"
sed -i '/config CFG80211_REQUIRE_SIGNED_REGDB/,/help/ s/default y/default n/' \
  "${SRC_DIR}/net/wireless/Kconfig"

cat > "${SRC_DIR}/dkms.conf" <<'EOF'
PACKAGE_NAME="backport-iwlwifi"
PACKAGE_VERSION="8613"
AUTOINSTALL="yes"
OBSOLETE_BY="5.4.0"

BUILT_MODULE_NAME[0]="compat"
BUILT_MODULE_LOCATION[0]="compat"
DEST_MODULE_LOCATION[0]="/updates"

BUILT_MODULE_NAME[1]="iwlwifi"
BUILT_MODULE_LOCATION[1]="drivers/net/wireless/intel/iwlwifi"
DEST_MODULE_LOCATION[1]="/updates"

BUILT_MODULE_NAME[2]="iwlxvt"
BUILT_MODULE_LOCATION[2]="drivers/net/wireless/intel/iwlwifi/xvt"
DEST_MODULE_LOCATION[2]="/updates"

BUILT_MODULE_NAME[3]="iwlmvm"
BUILT_MODULE_LOCATION[3]="drivers/net/wireless/intel/iwlwifi/mvm"
DEST_MODULE_LOCATION[3]="/updates"

BUILT_MODULE_NAME[4]="mac80211"
BUILT_MODULE_LOCATION[4]="net/mac80211"
DEST_MODULE_LOCATION[4]="/updates"

BUILT_MODULE_NAME[5]="cfg80211"
BUILT_MODULE_LOCATION[5]="net/wireless"
DEST_MODULE_LOCATION[5]="/updates"

num_cpu_cores()
{
  if [ -x /usr/bin/nproc ]; then
    nproc
  else
    echo "1"
  fi
}

MAKE="'make' -j$(num_cpu_cores) KLIB=/lib/modules/$kernelver"
CLEAN="'make' clean"
EOF

echo "Rebuilding DKMS module"
dkms remove -m backport-iwlwifi -v "${VERSION}" --all >/dev/null 2>&1 || true
dkms add -m backport-iwlwifi -v "${VERSION}"
dkms build -m backport-iwlwifi -v "${VERSION}" -k 4.9.337-tegra --force
dkms install -m backport-iwlwifi -v "${VERSION}" -k 4.9.337-tegra --force
depmod

echo "Attempting to load iwlwifi"
modprobe iwlwifi || true

echo
echo "Install complete"
echo "Run ./status.sh to verify the live state"
if [[ -r /sys/module/iwlwifi/version ]]; then
  echo "Live iwlwifi version: $(< /sys/module/iwlwifi/version)"
else
  echo "Live iwlwifi version: not loaded"
fi
