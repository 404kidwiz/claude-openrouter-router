#!/usr/bin/env bash
set -euo pipefail

repo_url="${CLAUDE_OPENROUTER_REPO_URL:-https://github.com/404kidwiz/claude-openrouter-router.git}"
ref="${CLAUDE_OPENROUTER_REF:-main}"
install_dir="${CLAUDE_OPENROUTER_INSTALL_DIR:-$HOME/.local/share/claude-openrouter-router}"
prefix="${PREFIX:-$HOME/.local}"

need_command() {
  command -v "$1" >/dev/null 2>&1
}

download_tarball() {
  local tmp_dir="$1"
  local tarball="$tmp_dir/repo.tar.gz"
  local archive_url="https://github.com/404kidwiz/claude-openrouter-router/archive/refs/heads/$ref.tar.gz"

  if need_command curl; then
    curl -fsSL "$archive_url" -o "$tarball"
  elif need_command wget; then
    wget -qO "$tarball" "$archive_url"
  else
    printf 'Error: install requires git, curl, or wget.\n' >&2
    exit 1
  fi

  mkdir -p "$install_dir"
  tar -xzf "$tarball" --strip-components=1 -C "$install_dir"
}

mkdir -p "$(dirname "$install_dir")"

if [[ -z "$install_dir" || "$install_dir" == "/" || "$install_dir" == "$HOME" || ! "$install_dir" == */* ]]; then
  printf 'Error: refusing to use install directory "%s". Set CLAUDE_OPENROUTER_INSTALL_DIR to a safe path.\n' "$install_dir" >&2
  exit 1
fi

if need_command git; then
  if [[ -d "$install_dir/.git" ]]; then
    git -C "$install_dir" fetch --quiet origin "$ref"
    git -C "$install_dir" checkout --quiet "$ref"
    git -C "$install_dir" pull --ff-only --quiet origin "$ref"
  else
    rm -rf "$install_dir"
    git clone --quiet --branch "$ref" "$repo_url" "$install_dir"
  fi
else
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' EXIT
  rm -rf "$install_dir"
  download_tarball "$tmp_dir"
fi

PREFIX="$prefix" "$install_dir/install.sh"

cat <<EOF

Installed Claude OpenRouter Router from:
  $repo_url

Install directory:
  $install_dir

Recommended next command:
  claude-openrouter --setup

Agent-safe note:
  Do not ask the AI agent to invent or expose an API key.
  The human user should create one at https://openrouter.ai/settings/keys.
EOF
