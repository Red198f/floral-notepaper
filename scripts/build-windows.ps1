$ErrorActionPreference = "Stop"

$RootDir = Split-Path -Parent $PSScriptRoot
Set-Location $RootDir

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
  throw "npm is required."
}

if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
  throw "Rust toolchain is required."
}

npm ci
npm run tauri build

$Version = (Get-Content "src-tauri/tauri.conf.json" -Raw | ConvertFrom-Json).version
$OutDir = Join-Path $RootDir "release-assets\windows"
New-Item -ItemType Directory -Path $OutDir -Force | Out-Null

$SetupSource = Get-ChildItem -Path "src-tauri/target/release/bundle/nsis" -File -Recurse -Filter "*.exe" |
  Sort-Object Length -Descending |
  Select-Object -First 1

if (-not $SetupSource) {
  throw "No Windows NSIS installer found."
}

Copy-Item $SetupSource.FullName (Join-Path $OutDir "floral-notepaper_${Version}_x64-setup.exe") -Force
Copy-Item "src-tauri/target/release/floral-notepaper.exe" (Join-Path $OutDir "floral-notepaper_${Version}.exe") -Force

Write-Host "Windows build finished. Artifacts are in $OutDir"
