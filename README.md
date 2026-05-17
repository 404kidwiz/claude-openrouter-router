# Claude OpenRouter Router

Small shell launchers for running Claude Code through OpenRouter's Anthropic-compatible endpoint.

The goal is simple: keep Claude Code's environment clean, make provider switching obvious, and offer a safe default that follows OpenRouter's Claude Code documentation.

## What This Does

`claude-openrouter` starts Claude Code with the OpenRouter environment variables that Claude Code expects:

```bash
ANTHROPIC_BASE_URL=https://openrouter.ai/api
ANTHROPIC_AUTH_TOKEN=$OPENROUTER_API_KEY
ANTHROPIC_API_KEY=
```

The empty `ANTHROPIC_API_KEY` is intentional. OpenRouter's Claude Code guide says it must be explicitly blank so Claude Code does not try to authenticate against Anthropic directly.

## Install

Clone and install:

```bash
git clone https://github.com/404kidwiz/claude-openrouter-router.git
cd claude-openrouter-router
./install.sh
```

Make sure `~/.local/bin` is on your `PATH`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Add your OpenRouter key to your shell profile:

```bash
export OPENROUTER_API_KEY="sk-or-v1-..."
```

Restart your shell, or run:

```bash
source ~/.zshrc
```

## Commands

Strict Claude compatibility:

```bash
claude-openrouter claude
```

Lowest-cost/free OpenRouter routing:

```bash
claude-openrouter free
claude-or-free
claude-or-auto-free
```

Named OpenRouter model profiles:

```bash
claude-nemotron
claude-ring
claude-owl
claude-pareto-code
claude-hunyuan
```

Generic model switcher:

```bash
claude-or-model nemotron
claude-or-model ring
claude-or-model owl
claude-or-model free
claude-or-model pareto-code
claude-or-model openrouter/owl-alpha
```

You can pass normal Claude Code arguments after the profile:

```bash
claude-openrouter claude -p "Reply with exactly OK"
claude-or-model nemotron -p "Reply with exactly OK"
```

## Profiles

| Profile | Model | Compatibility |
| --- | --- | --- |
| `claude` | Anthropic first-party Claude models through OpenRouter | Best / strict |
| `free` | `openrouter/free` | Best-effort |
| `nemotron` | `nvidia/nemotron-3-super-120b-a12b:free` | Best-effort |
| `ring` | `inclusionai/ring-2.6-1t` | Best-effort |
| `owl` | `openrouter/owl-alpha` | Best-effort |
| `pareto-code` | `openrouter/pareto-code` | Best-effort |
| `hunyuan` | `tencent/hy3-preview` | Best-effort |

Claude Code is optimized for Anthropic models. The `claude` profile is the reliable default. Non-Claude OpenRouter models can work through OpenRouter's Anthropic-compatible surface, but tool use, context features, speed, and formatting may vary by model/provider.

## Dry Run

Preview what will be launched without starting Claude Code:

```bash
claude-openrouter --dry-run claude
claude-openrouter --dry-run nemotron
```

Print the environment mapping:

```bash
claude-openrouter --print-env free
```

Secrets are redacted from dry-run output.

## Configuration

Required:

```bash
export OPENROUTER_API_KEY="sk-or-v1-..."
```

Optional:

```bash
export CLAUDE_OPENROUTER_DEFAULT_PROFILE=claude
export CLAUDE_OPENROUTER_MAIN_MODEL=sonnet
export CLAUDE_OPENROUTER_BASE_URL=https://openrouter.ai/api
export API_TIMEOUT_MS=3000000
```

## Recommended Usage

Use this when you care most about Claude Code compatibility:

```bash
claude-openrouter claude
```

Use this when you care most about lowest-cost/free routing and accept best-effort compatibility:

```bash
claude-openrouter free
```

Use named wrappers when you are experimenting with specific OpenRouter models:

```bash
claude-nemotron
claude-ring
claude-owl
claude-pareto-code
```

## Troubleshooting

If a command is not found:

```bash
export PATH="$HOME/.local/bin:$PATH"
rehash
```

If Claude Code authenticates against Anthropic instead of OpenRouter, check:

```bash
claude-openrouter --print-env claude
```

You should see:

```bash
ANTHROPIC_BASE_URL=https://openrouter.ai/api
ANTHROPIC_API_KEY=
ANTHROPIC_AUTH_TOKEN=<redacted>
```

If a non-Claude profile behaves strangely, retry with:

```bash
claude-openrouter claude
```

That profile uses Anthropic first-party Claude models through OpenRouter and is the intended compatibility path.

## References

- [OpenRouter Claude Code integration](https://openrouter.ai/docs/cookbook/coding-agents/claude-code-integration)
- [OpenRouter models](https://openrouter.ai/models)
- [Claude Code](https://code.claude.com)
