#!/usr/bin/env bash
#
# One-command TestFlight release.
#
#   scripts/release_ios_tf.sh                 # bump build number, build IPA, upload
#   scripts/release_ios_tf.sh --no-bump       # use pubspec version as-is
#   scripts/release_ios_tf.sh --version 1.1.0 # also set the version name (x.y.z)
#
# Steps: bump the build number in pubspec.yaml → flutter build ipa → upload via
# the App Store Connect API key. Export-compliance is already declared in
# ios/Runner/Info.plist (ITSAppUsesNonExemptEncryption=false), so no ASC prompt.
#
# Credentials are read from ~/.appstoreconnect/connect.json ("default" profile:
# keyId + issuerId), overridable via ASC_KEY_ID / ASC_ISSUER_ID. The matching
# AuthKey_<keyId>.p8 must live where altool looks (e.g. that same dir).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

BUMP=1
NEW_NAME=""
while [ $# -gt 0 ]; do
  case "$1" in
    --no-bump) BUMP=0 ;;
    --version) NEW_NAME="${2:?--version needs a value}"; shift ;;
    -h|--help) sed -n '2,15p' "$0"; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 1 ;;
  esac
  shift
done

# --- resolve version + build number from pubspec ---
cur="$(sed -n -E 's/^version: *//p' pubspec.yaml | head -1)"
[ -n "$cur" ] || { echo "error: no 'version:' in pubspec.yaml" >&2; exit 1; }
name="${cur%%+*}"
build="${cur#*+}"
[ "$build" = "$cur" ] && build=0      # no +N present yet
[ -n "$NEW_NAME" ] && name="$NEW_NAME"
[ "$BUMP" = "1" ] && build=$((build + 1))
newver="${name}+${build}"
if [ "$newver" != "$cur" ]; then
  sed -i '' -E "s/^version: .*/version: ${newver}/" pubspec.yaml
  echo "==> version: ${cur} -> ${newver}"
else
  echo "==> version: ${newver}"
fi

# --- credentials ---
CONNECT="$HOME/.appstoreconnect/connect.json"
KEY_ID="${ASC_KEY_ID:-}"
ISSUER_ID="${ASC_ISSUER_ID:-}"
if { [ -z "$KEY_ID" ] || [ -z "$ISSUER_ID" ]; } && [ -f "$CONNECT" ]; then
  KEY_ID="${KEY_ID:-$(python3 -c 'import json,sys;print(json.load(open(sys.argv[1]))["default"]["keyId"])' "$CONNECT")}"
  ISSUER_ID="${ISSUER_ID:-$(python3 -c 'import json,sys;print(json.load(open(sys.argv[1]))["default"]["issuerId"])' "$CONNECT")}"
fi
if [ -z "$KEY_ID" ] || [ -z "$ISSUER_ID" ]; then
  echo "error: missing ASC keyId/issuerId — set ASC_KEY_ID / ASC_ISSUER_ID or populate $CONNECT" >&2
  exit 1
fi
echo "==> ASC key ${KEY_ID}, issuer ${ISSUER_ID}"

# --- build ---
echo "==> flutter build ipa --release"
flutter build ipa --release

IPA="$(ls -t build/ios/ipa/*.ipa 2>/dev/null | head -1 || true)"
[ -n "$IPA" ] || { echo "error: no IPA produced under build/ios/ipa/" >&2; exit 1; }

# --- upload ---
echo "==> uploading ${IPA}"
xcrun altool --upload-app --type ios -f "$IPA" \
  --apiKey "$KEY_ID" --apiIssuer "$ISSUER_ID"

echo
echo "✅ ${newver} uploaded to TestFlight. (Remember to: git commit pubspec.yaml)"
