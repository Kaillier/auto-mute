#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
DERIVED_DIR="${TMPDIR:-/tmp}/自动静音-release-build"
APP_PATH="${DERIVED_DIR}/Build/Products/Release/自动静音.app"
DMG_PATH="${ROOT_DIR}/自动静音.dmg"
STAGING_DIR="${DERIVED_DIR}/dmg-staging"

xcodebuild \
  -project "${ROOT_DIR}/自动静音.xcodeproj" \
  -scheme "自动静音" \
  -configuration Release \
  -derivedDataPath "${DERIVED_DIR}" \
  build \
  CODE_SIGNING_ALLOWED=NO

python3 - "${STAGING_DIR}" "${DMG_PATH}" <<'PY'
from pathlib import Path
import shutil
import sys

staging = Path(sys.argv[1])
dmg = Path(sys.argv[2])
if staging.exists():
    shutil.rmtree(staging)
staging.mkdir(parents=True)
if dmg.exists():
    dmg.unlink()
PY

cp -R "${APP_PATH}" "${STAGING_DIR}/自动静音.app"
ln -s /Applications "${STAGING_DIR}/应用程序"
hdiutil create \
  -volname "自动静音" \
  -srcfolder "${STAGING_DIR}" \
  -ov \
  -format UDZO \
  "${DMG_PATH}"

echo "Created ${DMG_PATH}"
