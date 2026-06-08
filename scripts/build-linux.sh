#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v npm >/dev/null 2>&1; then
  echo "npm is required." >&2
  exit 1
fi

if ! command -v cargo >/dev/null 2>&1; then
  echo "Rust toolchain is required." >&2
  exit 1
fi

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This script must run on Linux (use WSL for Windows hosts)." >&2
  exit 1
fi

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y \
    libwebkit2gtk-4.1-dev \
    libayatana-appindicator3-dev \
    librsvg2-dev \
    patchelf \
    libssl-dev \
    libxdo-dev
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf install -y \
    webkit2gtk4.1-devel \
    libappindicator-gtk3-devel \
    librsvg2-devel \
    openssl-devel \
    libxdo-devel \
    patchelf
elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -Sy --needed \
    webkit2gtk-4.1 \
    libappindicator-gtk3 \
    librsvg \
    openssl \
    libxdo \
    patchelf \
    base-devel
else
  echo "Unsupported package manager. Install Tauri Linux dependencies manually." >&2
fi

npm ci
npm run tauri build -- --bundles deb,rpm

VERSION="$(node -p "JSON.parse(require('fs').readFileSync('src-tauri/tauri.conf.json','utf8')).version")"
OUT_DIR="$ROOT_DIR/release-assets/linux"
mkdir -p "$OUT_DIR"

copy_if_exists() {
  local pattern="$1"
  local dest="$2"
  local match
  match="$(find ${pattern} -type f 2>/dev/null | sort | head -n 1 || true)"
  if [[ -n "$match" ]]; then
    cp "$match" "$dest"
    echo "Collected: $dest"
  fi
}

copy_if_exists "src-tauri/target/release/bundle/deb/*.deb" "$OUT_DIR/floral-notepaper_${VERSION}_amd64.deb"
copy_if_exists "src-tauri/target/release/bundle/rpm/*.rpm" "$OUT_DIR/floral-notepaper-${VERSION}-1.x86_64.rpm"

if [ ! -f "$OUT_DIR/floral-notepaper_${VERSION}_amd64.deb" ] && [ ! -f "$OUT_DIR/floral-notepaper-${VERSION}-1.x86_64.rpm" ]; then
  echo "No Linux build artifacts found." >&2
  exit 1
fi

echo
echo "=== verify deb/rpm metadata ==="
chmod +x scripts/verify-linux-packages.sh
./scripts/verify-linux-packages.sh

echo
echo "Linux build finished. Artifacts are in $OUT_DIR"
echo "Tip: to also build AppImage, install xdg-utils and run: npm run tauri build -- --bundles appimage"
