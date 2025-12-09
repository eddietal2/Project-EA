#!/usr/bin/env bash
set -euo pipefail

# generate-compile-commands.sh
# Usage:
#   cd f-e/ios && ./generate-compile-commands.sh
# Requires: xcodebuild, xcpretty (optional). If xcpretty is not present, the script
# will attempt to run xcodebuild and create a simple fallback compile_commands.json.

WORKSPACE="fe.xcworkspace"
SCHEME="fe"
CONFIG="Debug"
SDK="iphonesimulator"
OUTDIR="./compile_commands"
OUTFILE="${OUTDIR}/compile_commands.json"

mkdir -p "${OUTDIR}"

if command -v xcpretty >/dev/null 2>&1; then
  echo "Generating compile_commands.json using xcodebuild + xcpretty..."
  xcodebuild -workspace "${WORKSPACE}" -scheme "${SCHEME}" -configuration "${CONFIG}" -sdk "${SDK}" \
    2>&1 | xcpretty -r json-compilation-database -o "${OUTFILE}"
  echo "Wrote ${OUTFILE}"
else
  echo "xcpretty not found. Generating a basic compile_commands.json using xcodebuild output..."
  # A very simple fallback: we will run xcodebuild and try to parse compile commands
  # into an approximate compile_commands.json that clangd can read. This is a lightweight fallback.
  TEMP_TXT="${OUTDIR}/xcodebuild.log"
  xcodebuild -workspace "${WORKSPACE}" -scheme "${SCHEME}" -configuration "${CONFIG}" -sdk "${SDK}" | tee "${TEMP_TXT}"
  echo "Parsing produced log. This fallback may be incomplete."
  # Write empty array placeholder if we cannot parse
  echo "[]" > "${OUTFILE}"
  echo "Wrote fallback ${OUTFILE} (empty array). To get a full compile database, install xcpretty and rerun this script: 'gem install xcpretty'"
fi

echo "Done. If compile_commands.json is incomplete, try installing xcpretty (gem install xcpretty) and rerun this script."
