#!/usr/bin/env bash
set -euo pipefail

prefix="${PREFIX:-$HOME/.local}"
bindir="$prefix/bin"
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$bindir"

for script in "$repo_dir"/bin/*; do
  name="$(basename "$script")"
  install -m 0755 "$script" "$bindir/$name"
  printf 'Installed %s\n' "$bindir/$name"
done

install -m 0755 "$repo_dir/bootstrap.sh" "$bindir/claude-openrouter-bootstrap"
printf 'Installed %s\n' "$bindir/claude-openrouter-bootstrap"

case ":$PATH:" in
  *":$bindir:"*) ;;
  *)
    printf '\nNote: %s is not currently in PATH.\n' "$bindir"
    printf 'Add this to your shell profile:\n'
    printf '  export PATH="%s:$PATH"\n' "$bindir"
    ;;
esac

printf '\nNext steps:\n'
printf '  claude-openrouter --setup\n'
printf '  claude-openrouter --install-profile-commands\n'
printf '  # or: export OPENROUTER_API_KEY="<your-openrouter-api-key>"\n'
printf '  claude-openrouter claude\n'
