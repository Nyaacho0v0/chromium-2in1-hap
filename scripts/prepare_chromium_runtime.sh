#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HAP_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CHROMIUM_ROOT="${1:-$(cd "${HAP_DIR}/../chromium_src" && pwd)}"
if [[ -d "${CHROMIUM_ROOT}/src" ]]; then
  CHROMIUM_SRC="${CHROMIUM_ROOT}/src"
else
  CHROMIUM_SRC="${CHROMIUM_ROOT}"
fi
OUT_DIR="${CHROMIUM_SRC}/out/musl_64"
SDK_LIB_DIR="${CHROMIUM_SRC}/ohos_sdk/openharmony/native/llvm/lib/aarch64-linux-ohos"
LIB_DIR="${HAP_DIR}/chromium/libs/arm64-v8a"
RESOURCE_DIR="${HAP_DIR}/web_engine/src/main/resources/resfile"

required_files=(
  "${OUT_DIR}/libadapter.so"
  "${OUT_DIR}/libchrome_main_web.so"
  "${SDK_LIB_DIR}/libc++_shared.so"
  "${OUT_DIR}/resources.pak"
  "${OUT_DIR}/chrome_100_percent.pak"
  "${OUT_DIR}/chrome_200_percent.pak"
  "${OUT_DIR}/icudtl.dat"
  "${OUT_DIR}/snapshot_blob.bin"
  "${OUT_DIR}/v8_context_snapshot.bin"
  "${OUT_DIR}/locales"
)

for path in "${required_files[@]}"; do
  if [[ ! -e "${path}" ]]; then
    echo "Missing Chromium runtime artifact: ${path}" >&2
    echo "Build chrome_main_web first, then run this script again." >&2
    exit 1
  fi
done

mkdir -p "${LIB_DIR}" "${RESOURCE_DIR}"
cp "${OUT_DIR}/libadapter.so" "${LIB_DIR}/"
cp "${OUT_DIR}/libchrome_main_web.so" "${LIB_DIR}/"
cp "${SDK_LIB_DIR}/libc++_shared.so" "${LIB_DIR}/"
cp "${OUT_DIR}/resources.pak" "${RESOURCE_DIR}/"
cp "${OUT_DIR}/chrome_100_percent.pak" "${RESOURCE_DIR}/"
cp "${OUT_DIR}/chrome_200_percent.pak" "${RESOURCE_DIR}/"
cp "${OUT_DIR}/icudtl.dat" "${RESOURCE_DIR}/"
cp "${OUT_DIR}/snapshot_blob.bin" "${RESOURCE_DIR}/"
cp "${OUT_DIR}/v8_context_snapshot.bin" "${RESOURCE_DIR}/"
rm -rf "${RESOURCE_DIR}/locales"
cp -R "${OUT_DIR}/locales" "${RESOURCE_DIR}/"

echo "Chromium runtime artifacts prepared for the HAP."
