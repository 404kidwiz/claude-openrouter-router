#compdef claude-openrouter
# Zsh completions for claude-openrouter
# Install: copy to ~/.zfunc/_claude-openrouter or /usr/local/share/zsh/site-functions/

_claude_openrouter() {
  local -a commands profiles

  commands=(
    '--setup[Guided first-run setup]'
    '--set-key:Save OpenRouter API key'
    '--set-key-stdin:Read API key from stdin'
    '--unset-key:Remove saved API key'
    '--set-default-profile:Change default profile'
    '--set-main-model:Main Claude Code model'
    '--set-opus-model:Set Opus model ID'
    '--set-sonnet-model:Set Sonnet model ID'
    '--set-haiku-model:Set Haiku model ID'
    '--set-base-url:Set OpenRouter base URL'
    '--set-timeout:Set API timeout in ms'
    '--show-config[Show config with redacted secrets]'
    '--config-path[Print config file path]'
    '--update[Pull latest and reinstall]'
    '--uninstall:Remove all installed files'
    'doctor[Run health checks]'
    '--switch[Interactive profile picker]'
    '--list-models:Search available models'
    '--cost[Show OpenRouter usage]'
    '--history[Show session history]'
    '--config-profile:Switch config profile'
    '--list-config-profiles[List config profiles]'
    '--add-profile:Add custom model profile'
    '--remove-profile:Remove custom profile'
    '--list-profiles[List all profiles]'
    '--dry-run[Preview launch without starting]'
    '--print-env[Print environment mapping]'
    '--version[Print version]'
    '--help[Show help]'
    'install-commands[Create shortcut commands]'
    'list-commands[List shortcut commands]'
    'commands-dir[Print commands directory]'
    'add-model:Add model and create shortcut'
  )

  profiles=(
    'claude:Anthropic Claude models via OpenRouter'
    'free:openrouter/free lowest cost'
    'nemotron:nvidia/nemotron-3-super-120b-a12b:free'
    'ring:inclusionai/ring-2.6-1t'
    'owl:openrouter/owl-alpha'
    'pareto-code:openrouter/pareto-code'
    'hunyuan:tencent/hy3-preview'
  )

  # Add custom profiles
  local profiles_file="${CLAUDE_OPENROUTER_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/claude-openrouter-router}/profiles"
  if [[ -f "$profiles_file" ]]; then
    while IFS='=' read -r name model; do
      [[ "$name" =~ ^[[:space:]]*$ || "$name" =~ ^# ]] && continue
      profiles+=("$name:$model")
    done < "$profiles_file"
  fi

  _arguments -C \
    '1: :->cmd' \
    '*:: :->args'

  case $state in
    cmd)
      _describe 'command' commands -- _describe 'profile' profiles
      ;;
    args)
      case $words[1] in
        --set-default-profile|--dry-run|--print-env)
          _describe 'profile' profiles
          ;;
        --config-profile)
          local -a config_profiles
          local config_dir="${CLAUDE_OPENROUTER_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/claude-openrouter-router}"
          for f in "$config_dir"/config-*; do
            [[ -f "$f" ]] || continue
            config_profiles+=("$(basename "$f" | sed 's/^config-//')")
          done
          _describe 'config-profile' config_profiles
          ;;
        --uninstall)
          _arguments '--yes[Confirm uninstall]'
          ;;
        --list-models)
          _message 'search term'
          ;;
      esac
      ;;
  esac
}

_claude_openrouter "$@"
