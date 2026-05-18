Running Claude Code through OpenRouter used to be 10 minutes of config hunting. Now it's one command.

I built **Claude OpenRouter Router** — a shell launcher that handles provider routing, model shortcuts, and setup so you can focus on coding instead of environment variables.

**One-line install:**
```bash
curl -fsSL https://raw.githubusercontent.com/404kidwiz/claude-openrouter-router/main/bootstrap.sh | bash
```

Prefer to review first?
```bash
curl -fsSL https://raw.githubusercontent.com/404kidwiz/claude-openrouter-router/main/bootstrap.sh -o bootstrap.sh
less bootstrap.sh
bash bootstrap.sh
```

**What it does:**
- Sets the right env vars (ANTHROPIC_BASE_URL, AUTH_TOKEN, blank API_KEY) per OpenRouter's documentation
- Guided terminal setup with a visual interface
- Custom model shortcuts — switch between Claude Opus, Sonnet, Haiku, or any of OpenRouter's 400+ models instantly
- Works with any AI agent that reads Anthropic-compatible env vars

**Who it's for:**
Developers using Claude Code who want provider flexibility without being locked in. Teams who want to control costs by routing through OpenRouter. Anyone testing multiple LLM models side-by-side.

**Why I built it:**
I use Claude Code daily and route through OpenRouter to access Claude models and alternatives without managing separate API keys. The manual config was the only friction point — this removes it entirely.

Open source. MIT license. Works on macOS and Linux.

Repo: https://github.com/404kidwiz/claude-openrouter-router

#ClaudeCode #Anthropic #LLM #APIGateway #ModelRouting #DevTools
