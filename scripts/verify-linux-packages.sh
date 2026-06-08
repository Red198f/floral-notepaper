#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DEB="$(find src-tauri/target/release/bundle/deb -maxdepth 1 -name '*.deb' 2>/dev/null | sort | head -n 1 || true)"
RPM="$(find src-tauri/target/release/bundle/rpm -maxdepth 1 -name '*.rpm' 2>/dev/null | sort | head -n 1 || true)"

if [ -z "$DEB" ] && [ -d release-assets/linux ]; then
  DEB="$(find release-assets/linux -maxdepth 1 -name '*.deb' 2>/dev/null | sort | head -n 1 || true)"
fi
if [ -z "$RPM" ] && [ -d release-assets/linux ]; then
  RPM="$(find release-assets/linux -maxdepth 1 -name '*.rpm' 2>/dev/null | sort | head -n 1 || true)"
fi

if [ -z "$DEB" ] && [ -z "$RPM" ]; then
  echo "No .deb or .rpm artifacts found. Run ./scripts/build-linux.sh or ./scripts/test-linux.sh first." >&2
  exit 1
fi

echo "=== Linux package verification ==="

if [ -n "$DEB" ]; then
  echo
  echo "[deb] $DEB"
  dpkg-deb -I "$DEB" | head -14
fi

if [ -n "$RPM" ]; then
  echo
  echo "[rpm] $RPM"
  if ! command -v rpm >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
      echo "Installing rpm CLI for metadata inspection..."
      sudo apt-get update -qq
      sudo apt-get install -y -qq rpm
    else
      echo "rpm command not found. Install the rpm package to verify .rpm metadata." >&2
      exit 1
    fi
  fi
  rpm -qip "$RPM" | head -20
  echo
  echo "[rpm] Requires:"
  rpm -qp --requires "$RPM" | grep -v '^rpmlib(' || true
fi

echo
echo "Package verification finished."
