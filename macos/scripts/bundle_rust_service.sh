#!/usr/bin/env bash
#
# Xcode build-phase script: bundle the Rust `agent-monitor-service` binary into
# the macOS app's Resources so the packaged app is self-contained. HostService
# (lib/services/host_service.dart) spawns the service from
# `<App>.app/Contents/Resources/agent-monitor-service`.
#
# Runs on every Runner build. Set BUNDLE_RUST_UNIVERSAL=1 (with the
# x86_64-apple-darwin rust target installed) to emit a universal binary.
set -euo pipefail

export PATH="$HOME/.cargo/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

BIN="agent-monitor-service"
SERVICE_DIR="$SRCROOT/../AgentMonitorService"
DEST_DIR="$BUILT_PRODUCTS_DIR/$FULL_PRODUCT_NAME/Contents/Resources"

if ! command -v cargo >/dev/null 2>&1; then
  echo "warning: cargo not found on PATH; skipping Rust service bundling. The app will not be able to host the service." >&2
  exit 0
fi

mkdir -p "$DEST_DIR"

if [ "${BUNDLE_RUST_UNIVERSAL:-0}" = "1" ] \
   && rustup target list --installed 2>/dev/null | grep -q x86_64-apple-darwin; then
  echo "Building universal agent-monitor-service (arm64 + x86_64)…"
  cargo build --release --manifest-path "$SERVICE_DIR/Cargo.toml" --target aarch64-apple-darwin
  cargo build --release --manifest-path "$SERVICE_DIR/Cargo.toml" --target x86_64-apple-darwin
  lipo -create \
    "$SERVICE_DIR/target/aarch64-apple-darwin/release/$BIN" \
    "$SERVICE_DIR/target/x86_64-apple-darwin/release/$BIN" \
    -output "$DEST_DIR/$BIN"
else
  echo "Building agent-monitor-service (host arch)…"
  cargo build --release --manifest-path "$SERVICE_DIR/Cargo.toml"
  cp "$SERVICE_DIR/target/release/$BIN" "$DEST_DIR/$BIN"
fi

chmod +x "$DEST_DIR/$BIN"
echo "Bundled $BIN → $DEST_DIR"
