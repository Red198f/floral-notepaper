#!/usr/bin/env bash
set -euo pipefail

NEW=/mnt/e/project/floral-notepaper-main/floral-notepaper-main_new/floral-notepaper-main
cd "$NEW"

if [ -f "$HOME/.cargo/env" ]; then
  # shellcheck disable=SC1091
  source "$HOME/.cargo/env"
fi

echo "=== npm ci (Linux native deps) ==="
rm -rf node_modules
npm ci

echo "=== npm test (Linux) ==="
npm test

echo
echo "=== npm run build (Linux) ==="
npm run build

echo
echo "=== tauri build deb,rpm (Linux) ==="
npm run tauri build -- --bundles deb,rpm

echo
ls -lh src-tauri/target/release/bundle/deb/*.deb
ls -lh src-tauri/target/release/bundle/rpm/*.rpm

echo
echo "=== deb metadata ==="
dpkg-deb -I src-tauri/target/release/bundle/deb/*.deb | head -12

echo
echo "=== rpm metadata ==="
if ! command -v rpm >/dev/null 2>&1; then
  sudo apt-get update -qq
  sudo apt-get install -y -qq rpm
fi
rpm -qip src-tauri/target/release/bundle/rpm/*.rpm | head -20
echo
echo "[rpm] Requires:"
rpm -qp --requires src-tauri/target/release/bundle/rpm/*.rpm | grep -v '^rpmlib(' || true

echo
echo "=== binary smoke test ==="
timeout 5 src-tauri/target/release/floral-notepaper >/tmp/fn-smoke.log 2>&1 || true
tail -3 /tmp/fn-smoke.log

mkdir -p release-assets/linux
VERSION="$(node -p "JSON.parse(require('fs').readFileSync('src-tauri/tauri.conf.json','utf8')).version")"
cp src-tauri/target/release/bundle/deb/*.deb "release-assets/linux/floral-notepaper_${VERSION}_amd64.deb"
cp src-tauri/target/release/bundle/rpm/*.rpm "release-assets/linux/floral-notepaper-${VERSION}-1.x86_64.rpm"
echo
echo "Artifacts copied to release-assets/linux/"
