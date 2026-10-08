#!/usr/bin/env bash
# Builds IDFlow.xcframework.zip for a release and writes its version + checksum
# into Package.swift and IDFlow.podspec. Does not commit, tag or upload.
#
# Usage: scripts/prepare-release.sh <version>
set -euo pipefail

VERSION="${1:?usage: scripts/prepare-release.sh <version>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FRAMEWORK="IDFlow.xcframework"
ZIP="IDFlow.xcframework.zip"
cd "$ROOT"

[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "error: version must be X.Y.Z, got '$VERSION'" >&2; exit 1; }

[[ -d "$FRAMEWORK" ]] || { echo "error: $FRAMEWORK not found in $ROOT" >&2; exit 1; }

# Each slice must be built for the version being released, otherwise SPM and
# Pods would ship a binary whose bundle version (and the sdkVersion it reports
# at runtime) disagrees with the tag. ALLOW_VERSION_MISMATCH=1 permits a
# packaging-only release that re-ships an unchanged binary.
for plist in "$FRAMEWORK"/*/IDFlow.framework/Info.plist; do
  built="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$plist")"
  if [[ "$built" != "$VERSION" ]]; then
    if [[ "${ALLOW_VERSION_MISMATCH:-0}" == "1" ]]; then
      echo "warning: $plist has version $built, releasing as $VERSION" >&2
    else
      echo "error: $plist has version $built, expected $VERSION (set ALLOW_VERSION_MISMATCH=1 to re-ship an unchanged binary)" >&2
      exit 1
    fi
  fi
done

# Finder metadata and extended attributes would change the zip bytes (and the
# checksum) or add a __MACOSX/ entry that SPM rejects as unexpected content.
find "$FRAMEWORK" -name .DS_Store -delete

rm -f "$ZIP"
ditto -c -k --norsrc --noextattr --keepParent "$FRAMEWORK" "$ZIP"
CHECKSUM="$(swift package compute-checksum "$ZIP")"

sed -i '' -E \
  -e "s#releases/download/[^/]+/$ZIP#releases/download/$VERSION/$ZIP#" \
  -e "s#checksum: \"[^\"]*\"#checksum: \"$CHECKSUM\"#" \
  Package.swift
sed -i '' -E "s#(spec\.version[[:space:]]*=[[:space:]]*)\"[^\"]*\"#\1\"$VERSION\"#" IDFlow.podspec

grep -q "checksum: \"$CHECKSUM\"" Package.swift || { echo "error: checksum not written to Package.swift" >&2; exit 1; }
grep -q "releases/download/$VERSION/$ZIP" Package.swift || { echo "error: URL version not written to Package.swift" >&2; exit 1; }
swift package dump-package > /dev/null

cat <<EOF
Prepared $VERSION
  zip:      $ROOT/$ZIP
  checksum: $CHECKSUM

Next (in order):
  git add Package.swift IDFlow.podspec README.md .gitignore scripts/
  git commit -m "release: $VERSION"
  git tag $VERSION && git push origin HEAD $VERSION
  gh release create $VERSION $ZIP --title $VERSION --notes "IDFlow $VERSION"
  # verify SPM + Pods integration, then:
  pod trunk push IDFlow.podspec
Never replace the release asset after tagging; ship a new version instead.
EOF
