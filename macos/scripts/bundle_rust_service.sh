#!/usr/bin/env bash
#
# Xcode build-phase script: build the `amux` binary with the `full` feature and
# bundle it into the macOS app's Resources as `agent-monitor-service`, so the
# packaged app is self-contained. HostService (lib/services/host_service.dart)
# spawns it as
#   <App>.app/Contents/Resources/agent-monitor-service serve --foreground --port 8797
#
# The agent-monitor server now lives in the sibling `amux` repo (one core, built
# with `--features full` for the macOS host extras). Override its location with
# AMUX_SRC. amux embeds its own web client, so no separate web/ dir is bundled.
#
# Runs on every Runner build. Set BUNDLE_RUST_UNIVERSAL=1 (with the
# x86_64-apple-darwin rust target installed) to emit a universal binary.
set -euo pipefail

export PATH="$HOME/.cargo/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

DEST_BIN="agent-monitor-service"     # name the host app expects
SRC_BIN="amux"                        # what cargo produces
AMUX_SRC="${AMUX_SRC:-$SRCROOT/../../amux}"
DEST_DIR="$BUILT_PRODUCTS_DIR/$FULL_PRODUCT_NAME/Contents/Resources"

if ! command -v cargo >/dev/null 2>&1; then
  echo "warning: cargo not found on PATH; skipping Rust service bundling. The app will not be able to host the service." >&2
  exit 0
fi
if [ ! -f "$AMUX_SRC/Cargo.toml" ]; then
  echo "warning: amux source not found at '$AMUX_SRC' (set AMUX_SRC=/path/to/amux); skipping service bundling." >&2
  exit 0
fi

mkdir -p "$DEST_DIR"

if [ "${BUNDLE_RUST_UNIVERSAL:-0}" = "1" ] \
   && rustup target list --installed 2>/dev/null | grep -q x86_64-apple-darwin; then
  echo "Building universal amux --features full (arm64 + x86_64)…"
  cargo build --release --features full --manifest-path "$AMUX_SRC/Cargo.toml" --target aarch64-apple-darwin
  cargo build --release --features full --manifest-path "$AMUX_SRC/Cargo.toml" --target x86_64-apple-darwin
  lipo -create \
    "$AMUX_SRC/target/aarch64-apple-darwin/release/$SRC_BIN" \
    "$AMUX_SRC/target/x86_64-apple-darwin/release/$SRC_BIN" \
    -output "$DEST_DIR/$DEST_BIN"
else
  echo "Building amux --features full (host arch)…"
  cargo build --release --features full --manifest-path "$AMUX_SRC/Cargo.toml"
  cp "$AMUX_SRC/target/release/$SRC_BIN" "$DEST_DIR/$DEST_BIN"
fi

chmod +x "$DEST_DIR/$DEST_BIN"
echo "Bundled amux (full) → $DEST_DIR/$DEST_BIN"

# --- Bundle rmux (the multiplexer amux drives) so the app is self-contained.
# host_service.dart sets AMUX_MUX to this bundled binary at launch.
RMUX_VERSION="${RMUX_VERSION:-0.8.0}"
RMUX_DEST="$DEST_DIR/rmux"

bundle_rmux() {
  # Prefer an already-installed rmux (e.g. Homebrew) to avoid a network hop.
  local found
  found="$(command -v rmux || true)"
  if [ -n "$found" ]; then
    cp "$found" "$RMUX_DEST"
    echo "Bundled rmux (from $found) → $RMUX_DEST"
    return 0
  fi

  # Otherwise download the prebuilt binary for the host arch.
  local arch asset tmp
  case "$(uname -m)" in
    arm64) arch="aarch64" ;;
    x86_64) arch="x86_64" ;;
    *) echo "warning: unknown arch $(uname -m); skipping rmux bundling." >&2; return 0 ;;
  esac
  asset="rmux-${RMUX_VERSION}-macos-${arch}.tar.gz"
  tmp="$(mktemp -d)"
  if curl -fsSL "https://github.com/helvesec/rmux/releases/download/v${RMUX_VERSION}/${asset}" -o "$tmp/rmux.tgz"; then
    tar -xzf "$tmp/rmux.tgz" -C "$tmp"
    local bin
    bin="$(find "$tmp" -type f -name rmux | head -1)"
    if [ -n "$bin" ]; then
      cp "$bin" "$RMUX_DEST"
      echo "Bundled rmux (downloaded $asset) → $RMUX_DEST"
    else
      echo "warning: rmux binary not found in $asset; skipping." >&2
    fi
  else
    echo "warning: failed to download $asset; skipping rmux bundling (app will fall back to PATH)." >&2
  fi
  rm -rf "$tmp"
}

bundle_rmux
[ -f "$RMUX_DEST" ] && chmod +x "$RMUX_DEST"

