#!/usr/bin/env bash
#
# Build, sign, and package the macOS app into a distributable DMG.
#
# Default (no env vars): ad-hoc signed DMG. It installs and runs, but Gatekeeper
# shows "unidentified developer" — users right-click → Open the first time.
#
# Full Developer ID + notarization (no Gatekeeper warning) — requires an Apple
# Developer account ($99/yr). Provide:
#   SIGN_IDENTITY  = "Developer ID Application: Your Name (TEAMID)"
#   NOTARY_PROFILE = a notarytool keychain profile, created once with:
#       xcrun notarytool store-credentials "<profile>" \
#         --apple-id you@example.com --team-id TEAMID --password <app-specific-pw>
#
# Optional:
#   UNIVERSAL=1    build a universal (arm64 + x86_64) service binary.
#                  Needs: rustup target add x86_64-apple-darwin
#
# Usage:
#   scripts/package_macos.sh                       # ad-hoc DMG
#   SIGN_IDENTITY="Developer ID Application: …" \
#     NOTARY_PROFILE=agent-port scripts/package_macos.sh   # signed + notarized
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

APP="build/macos/Build/Products/Release/agent_port.app"
DMG="build/AgentPort.dmg"
ENTITLEMENTS="macos/Runner/Release.entitlements"
SERVICE_BIN="Contents/Resources/agent-monitor-service"

echo "==> flutter build web --release (bundled into the app as the browser client)"
flutter build web --release

echo "==> flutter build macos --release"
BUNDLE_RUST_UNIVERSAL="${UNIVERSAL:-0}" flutter build macos --release

[ -d "$APP" ] || { echo "error: $APP not found" >&2; exit 1; }
[ -f "$APP/$SERVICE_BIN" ] || { echo "error: service binary missing in bundle (build phase failed?)" >&2; exit 1; }

if [ -n "${SIGN_IDENTITY:-}" ]; then
  echo "==> Codesigning with Developer ID (hardened runtime)"
  # Sign inside-out: embedded service + nested frameworks, then the app.
  codesign --force --options runtime --timestamp -s "$SIGN_IDENTITY" "$APP/$SERVICE_BIN"
  if [ -d "$APP/Contents/Frameworks" ]; then
    find "$APP/Contents/Frameworks" -maxdepth 1 \( -name "*.framework" -o -name "*.dylib" \) -print0 |
      while IFS= read -r -d '' f; do
        codesign --force --options runtime --timestamp -s "$SIGN_IDENTITY" "$f" || true
      done
  fi
  codesign --force --options runtime --timestamp \
    --entitlements "$ENTITLEMENTS" -s "$SIGN_IDENTITY" "$APP"
  codesign --verify --deep --strict --verbose=2 "$APP"
else
  echo "==> Ad-hoc codesigning (no Developer ID — Gatekeeper will warn on first open)"
  codesign --force --deep -s - "$APP"
fi

echo "==> Building DMG: $DMG"
rm -f "$DMG"
STAGE="$(mktemp -d)"
cp -R "$APP" "$STAGE/"
ln -s /Applications "$STAGE/Applications"
hdiutil create -volname "Agent Port" -srcfolder "$STAGE" -ov -format UDZO "$DMG" >/dev/null
rm -rf "$STAGE"

if [ -n "${NOTARY_PROFILE:-}" ]; then
  echo "==> Notarizing (a few minutes)…"
  xcrun notarytool submit "$DMG" --keychain-profile "$NOTARY_PROFILE" --wait
  echo "==> Stapling"
  xcrun stapler staple "$DMG"
  xcrun stapler validate "$DMG"
fi

echo
echo "Done: $DMG"
[ -z "${SIGN_IDENTITY:-}" ] && echo "Note: ad-hoc build. To open: right-click the app → Open (once)."
