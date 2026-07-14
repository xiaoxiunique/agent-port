<#
.SYNOPSIS
  Bundle amux.exe + rmux.exe next to the built Flutter Windows Runner, so the
  packaged app can host the agent-monitor service self-contained (no separate
  installs). host_service.dart resolves amux.exe beside the Runner and sets
  AMUX_MUX to the bundled rmux.exe.

  Run AFTER `flutter build windows --release`, from the agent-port repo root.
#>
param(
  # Path to the sibling amux repo checkout (CI passes this explicitly).
  [string]$AmuxSrc = (Join-Path $PSScriptRoot "..\..\..\amux"),
  [string]$RmuxVersion = "0.8.0",
  # Where the Flutter Windows Runner + DLLs live (relative to repo root).
  [string]$Dest = "build\windows\x64\runner\Release"
)
$ErrorActionPreference = "Stop"

if (-not (Test-Path $Dest)) {
  throw "Runner output dir not found: $Dest (run 'flutter build windows --release' first)"
}

# --- 1. Build amux.exe (core only; the `full` feature pulls macOS-only deps) ---
if (-not (Test-Path (Join-Path $AmuxSrc "Cargo.toml"))) {
  throw "amux source not found at '$AmuxSrc' (pass -AmuxSrc <path>)"
}
Write-Host "Building amux.exe (release) from $AmuxSrc ..."
Push-Location $AmuxSrc
try {
  cargo build --release
  if ($LASTEXITCODE -ne 0) { throw "cargo build failed ($LASTEXITCODE)" }
} finally {
  Pop-Location
}
Copy-Item (Join-Path $AmuxSrc "target\release\amux.exe") (Join-Path $Dest "amux.exe") -Force
Write-Host "Bundled amux.exe -> $Dest"

# --- 2. Download the prebuilt rmux.exe ---
$asset = "rmux-$RmuxVersion-windows-x86_64.zip"
$url = "https://github.com/helvesec/rmux/releases/download/v$RmuxVersion/$asset"
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid())
New-Item -ItemType Directory -Path $tmp | Out-Null
try {
  Write-Host "Downloading $url ..."
  Invoke-WebRequest -Uri $url -OutFile (Join-Path $tmp "rmux.zip")
  Expand-Archive (Join-Path $tmp "rmux.zip") -DestinationPath $tmp -Force
  $rmux = Get-ChildItem -Path $tmp -Recurse -Filter "rmux.exe" | Select-Object -First 1
  if (-not $rmux) { throw "rmux.exe not found inside $asset" }
  Copy-Item $rmux.FullName (Join-Path $Dest "rmux.exe") -Force
  Write-Host "Bundled rmux.exe -> $Dest"
} finally {
  Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}

Write-Host "Done. Release/ now contains Runner + amux.exe + rmux.exe."
