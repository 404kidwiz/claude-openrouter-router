# Install With An AI Agent

Give this page to an AI coding agent or LLM that can run terminal commands on your machine.

Raw link:

```text
https://raw.githubusercontent.com/404kidwiz/claude-openrouter-router/main/AGENT_INSTALL.md
```

## Agent Instructions

Install Claude OpenRouter Router for the user.

Run this command:

```bash
curl -fsSL https://raw.githubusercontent.com/404kidwiz/claude-openrouter-router/main/bootstrap.sh | bash
```

If the user prefers to review scripts before execution, download the file first and inspect it before running it.

If `curl` is unavailable, use:

```bash
wget -qO- https://raw.githubusercontent.com/404kidwiz/claude-openrouter-router/main/bootstrap.sh | bash
```

After installation, verify:

```bash
command -v claude-openrouter
claude-openrouter --version
claude-openrouter --show-config
```

Then tell the user to run:

```bash
claude-openrouter --setup
```

## Important Secret Handling

Do not invent, request, print, log, or commit the user's OpenRouter API key.

The user should create an API key here:

```text
https://openrouter.ai/settings/keys
```

If the user explicitly provides an API key and wants you to save it locally, prefer stdin so it is less likely to land in shell history:

```bash
printf '%s' '<OPENROUTER_API_KEY>' | claude-openrouter --set-key-stdin
```

Then verify that the key is redacted:

```bash
claude-openrouter --show-config
```

## Optional Agent Tasks

If the user wants lowest-cost/free routing by default:

```bash
claude-openrouter --set-default-profile free
```

If the user wants strict Claude Code compatibility by default:

```bash
claude-openrouter --set-default-profile claude
```

If the user wants a custom OpenRouter model:

```bash
claude-openrouter --add-profile <name> <provider/model-id>
```

Example:

```bash
claude-openrouter --add-profile qwen qwen/qwen3-coder:free
```

Run a safe dry-run:

```bash
claude-openrouter --dry-run
```

## Success Criteria

The install is complete when:

- `command -v claude-openrouter` resolves.
- `claude-openrouter --version` prints a version.
- `claude-openrouter --show-config` runs without exposing the full API key.
- The user knows to run `claude-openrouter --setup` if they have not configured a key yet.
