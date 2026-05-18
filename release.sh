#!/usr/bin/env bash
set -euo pipefail

# Release script: creates signed tag, generates checksums, pushes
# Usage: ./release.sh [version]
# Requires: git, gpg, sha256sum (or shasum)

VERSION="${1:-}"
REPO="404kidwiz/claude-openrouter-router"

if [[ -z "$VERSION" ]]; then
  VERSION="$(cat VERSION 2>/dev/null || true)"
  [[ -n "$VERSION" ]] || { printf 'Usage: %s [version]\n' "$0" >&2; exit 1; }
fi

printf 'Releasing version: %s\n' "$VERSION"

# Update VERSION file
printf '%s\n' "$VERSION" > VERSION

# Update version in main script
sed -i.bak "s/^VERSION=.*/VERSION=\"$VERSION\"/" bin/claude-openrouter && rm -f bin/claude-openrouter.bak

# Verify script syntax
bash -n bin/claude-openrouter || { printf 'Syntax error in main script\n' >&2; exit 1; }

# Stage changes
git add VERSION bin/claude-openrouter

# Commit
git commit -m "Release v${VERSION}" || true

# Create tarball
TARBALL="/tmp/claude-openrouter-${VERSION}.tar.gz"
git archive --format=tar.gz --prefix="claude-openrouter-${VERSION}/" -o "$TARBALL" HEAD

# Generate SHA256 checksum
if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$TARBALL" | awk '{print $1}' > "/tmp/claude-openrouter-${VERSION}.sha256"
elif command -v shasum >/dev/null 2>&1; then
  shasum -a 256 "$TARBALL" | awk '{print $1}' > "/tmp/claude-openrouter-${VERSION}.sha256"
else
  printf 'Error: sha256sum or shasum required\n' >&2; exit 1
fi

CHECKSUM="$(cat "/tmp/claude-openrouter-${VERSION}.sha256")"
printf 'SHA256: %s\n' "$CHECKSUM"

# Create signed git tag
if command -v gpg >/dev/null 2>&1; then
  git tag -s "v${VERSION}" -m "Release v${VERSION}

SHA256: ${CHECKSUM}
" || { printf 'Tag creation failed. Check GPG key.\n' >&2; exit 1; }
  printf 'Signed tag v%s created\n' "$VERSION"
else
  git tag -a "v${VERSION}" -m "Release v${VERSION}

SHA256: ${CHECKSUM}
"
  printf 'Unsigned tag v%s created (GPG not found)\n' "$VERSION"
fi

printf '\nNext steps:\n'
printf '  git push origin main --tags\n'
printf '  gh release create v%s --title "v%s" --notes "SHA256: %s" "$TARBALL"\n' "$VERSION" "$VERSION" "$CHECKSUM"

# Cleanup
rm -f "$TARBALL" "/tmp/claude-openrouter-${VERSION}.sha256"
