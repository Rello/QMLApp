#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${1:-${ROOT_DIR}/build/macos}"

resolve_qt_prefix() {
  local candidate="${QT_ROOT_DIR:-${Qt6_DIR:-}}"

  if [[ -n "${candidate}" ]]; then
    if [[ -d "${candidate}/lib/cmake/Qt6" ]]; then
      printf '%s\n' "${candidate}"
      return 0
    fi

    if [[ "${candidate}" == */lib/cmake/Qt6 ]]; then
      (cd "${candidate}/../../.." && pwd)
      return 0
    fi
  fi

  if [[ -d "${HOME}/Qt" ]]; then
    while IFS= read -r path; do
      if [[ -d "${path}/lib/cmake/Qt6" ]]; then
        printf '%s\n' "${path}"
        return 0
      fi
    done < <(find "${HOME}/Qt" -maxdepth 3 -type d \( -name macos -o -name clang_64 \) | sort -r)
  fi

  return 1
}

QT_PREFIX="$(resolve_qt_prefix || true)"
if [[ -z "${QT_PREFIX}" ]]; then
  echo "Qt 6 was not found. Set QT_ROOT_DIR or Qt6_DIR before running this script." >&2
  exit 1
fi

cmake -S "${ROOT_DIR}" -B "${BUILD_DIR}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_PREFIX_PATH="${QT_PREFIX}"

cmake --build "${BUILD_DIR}" --config Release

APP_PATH="$(find "${BUILD_DIR}" -maxdepth 4 -name '*.app' -type d | head -n 1)"
if [[ -n "${APP_PATH}" ]]; then
  echo "Built app bundle: ${APP_PATH}"
else
  echo "Build finished, but no .app bundle was found under ${BUILD_DIR}" >&2
  exit 1
fi
