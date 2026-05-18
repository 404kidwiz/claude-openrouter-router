class ClaudeOpenrouter < Formula
  desc "Shell launcher for running Claude Code through OpenRouter"
  homepage "https://github.com/404kidwiz/claude-openrouter-router"
  url "https://github.com/404kidwiz/claude-openrouter-router/archive/refs/heads/main.tar.gz"
  version "0.7.0"
  license "MIT"
  head "https://github.com/404kidwiz/claude-openrouter-router.git", branch: "main"

  depends_on "bash"

  def install
    bin.install Dir["bin/*"]
    bash_completion.install "completions/claude-openrouter.bash" => "claude-openrouter"
    zsh_completion.install "completions/claude-openrouter.zsh" => "_claude-openrouter"
  end

  def caveats
    <<~EOS
      Run the guided setup to configure your OpenRouter API key:
        claude-openrouter --setup

      Get an API key at: https://openrouter.ai/settings/keys

      Install shortcut commands (claude-ring, claude-owl, etc.):
        claude-openrouter install-commands

      Shell completions installed. Restart your shell or run:
        source #{bash_completion}/claude-openrouter
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude-openrouter --version")
  end
end
