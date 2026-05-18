#!/usr/bin/env bash
# Bash completions for claude-openrouter
# Install: source this file in your ~/.bashrc or copy to /etc/bash_completion.d/

_claude_openrouter_completions() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  local commands="--setup --set-key --set-key-stdin --unset-key --set-default-profile --set-main-model --set-opus-model --set-sonnet-model --set-haiku-model --set-base-url --set-timeout --show-config --config-path --update --uninstall doctor --switch --list-models --cost --history --config-profile --list-config-profiles --add-profile --remove-profile --list-profiles --dry-run --print-env --version --help install-commands list-commands commands-dir add-model"

  local profiles="claude free nemotron ring owl pareto-code hunyuan"

  # Custom profiles from config
  local profiles_file="${CLAUDE_OPENROUTER_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/claude-openrouter-router}/profiles"
  if [[ -f "$profiles_file" ]]; then
    local custom_profiles
    custom_profiles="$(awk -F= '/^[^#]/{printf "%s ", $1}' "$profiles_file" 2>/dev/null)"
    profiles="$profiles $custom_profiles"
  fi

  if [[ ${COMP_CWORD} -eq 1 ]]; then
    COMPREPLY=( $(compgen -W "$commands $profiles" -- "$cur") )
    return 0
  fi

  case "$prev" in
    --set-default-profile)
      COMPREPLY=( $(compgen -W "$profiles" -- "$cur") )
      return 0
      ;;
    --config-profile)
      local config_dir="${CLAUDE_OPENROUTER_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/claude-openrouter-router}"
      local profile_names=""
      for f in "$config_dir"/config-*; do
        [[ -f "$f" ]] || continue
        profile_names="$profile_names $(basename "$f" | sed 's/^config-//')"
      done
      COMPREPLY=( $(compgen -W "$profile_names" -- "$cur") )
      return 0
      ;;
    --set-main-model|--set-opus-model|--set-sonnet-model|--set-haiku-model)
      COMPREPLY=( $(compgen -W "sonnet opus haiku anthropic/claude-sonnet-4-6 anthropic/claude-opus-4-7 anthropic/claude-haiku-4-5-20251001" -- "$cur") )
      return 0
      ;;
    --set-base-url)
      COMPREPLY=( $(compgen -W "https://openrouter.ai/api" -- "$cur") )
      return 0
      ;;
    --uninstall)
      COMPREPLY=( $(compgen -W "--yes" -- "$cur") )
      return 0
      ;;
    --add-profile|--remove-profile)
      COMPREPLY=( $(compgen -W "$profiles" -- "$cur") )
      return 0
      ;;
    --list-models)
      COMPREPLY=( $(compgen -W "claude free qwen gemini llama deepseek" -- "$cur") )
      return 0
      ;;
    --dry-run|--print-env)
      COMPREPLY=( $(compgen -W "$profiles" -- "$cur") )
      return 0
      ;;
  esac

  # Profile name completion for positional arg
  if [[ "$cur" != -* ]]; then
    COMPREPLY=( $(compgen -W "$profiles" -- "$cur") )
  fi
}

complete -F _claude_openrouter_completions claude-openrouter

# Completions for shortcut commands
_claude_shortcut_completions() {
  local cur
  cur="${COMP_WORDS[COMP_CWORD]}"
  # Shortcuts just pass args to claude, so complete with claude's args
  COMPREPLY=( $(compgen -W "-p --help --version" -- "$cur") )
}

complete -F _claude_shortcut_completions claude-ring claude-owl claude-nemotron claude-pareto-code claude-hunyuan claude-or-free claude-or-model claude-openrouter-claude
