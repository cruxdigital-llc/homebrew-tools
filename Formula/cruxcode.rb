# cruxcode: pi (pi.dev) with Crux Digital's harness (GLaDOS workflows + TypeSafe Jev).
#
# Source of truth: github.com/cruxdigital-llc/cruxcode/brew/cruxcode.rb. Published to the
# cruxdigital-llc/homebrew-tools tap as Formula/cruxcode.rb.
#
# The formula installs pi itself (pinned; the harness uses pi internals) and a `cruxcode` command.
# The harness lives in a private repo, so it is not downloaded here: the first `cruxcode` run fetches
# it with the person's own GitHub access, and `cruxcode update` pulls new versions.
class Cruxcode < Formula
  desc "Crux Digital's coding harness: pi with GLaDOS workflows and TypeSafe Jev"
  homepage "https://github.com/cruxdigital-llc/homebrew-tools"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-1.2.0.tgz"
  version "0.3.1"
  sha256 "1dfed308f46a69aec06bf9dc20700ddc6fe2370b1898f01334b7898397541e66"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args, "--ignore-scripts"

    # pi's terminal UI ships prebuilt native modules for every platform; keep only this one.
    platform = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    libexec.glob("lib/node_modules/**/prebuilds/*").each do |dir|
      rm_r dir if dir.directory? && dir.basename.to_s != platform
    end

    (bin/"cruxcode").write <<~SH
      #!/bin/bash
      # cruxcode #{version}: pi with Crux Digital's harness. Installed by Homebrew; do not edit.
      set -euo pipefail

      PI="#{libexec}/bin/pi"
      export PATH="#{formula_opt_bin("node")}:$PATH"
      REPO="git:github.com/cruxdigital-llc/cruxcode"
      AGENT_DIR="${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
      HARNESS="$AGENT_DIR/git/github.com/cruxdigital-llc/cruxcode"

      install_harness() {
        echo "cruxcode: fetching the harness from github.com/cruxdigital-llc/cruxcode (uses your GitHub access)…"
        if ! "$PI" install "$REPO"; then
          echo "cruxcode: couldn't fetch it. Run 'gh auth login' and 'gh auth setup-git', and make sure you can see cruxdigital-llc/cruxcode." >&2
          exit 1
        fi
        # Make cruxcode/auto the default model, unless one is already chosen.
        node -e '
          const fs = require("fs"), f = process.argv[1];
          const s = fs.existsSync(f) ? JSON.parse(fs.readFileSync(f, "utf8")) : {};
          if (!s.defaultModel) {
            Object.assign(s, { defaultProvider: "cruxcode", defaultModel: "auto" });
            fs.writeFileSync(f, JSON.stringify(s, null, 2) + "\\n");
          }' "$AGENT_DIR/settings.json"
        echo "cruxcode: ready. Starting; a setup checklist inside will walk you through signing in."
      }

      case "${1:-}" in
        --version|-v)
          echo "cruxcode #{version} (pi $("$PI" --version))"
          exit 0
          ;;
        update)
          [ -d "$HARNESS" ] || install_harness
          exec "$PI" update "$REPO"
          ;;
      esac

      [ -d "$HARNESS" ] || install_harness
      exec "$PI" "$@"
    SH
  end

  def caveats
    <<~EOS
      Run `cruxcode` in any repo. The first run fetches the harness from the private
      cruxdigital-llc/cruxcode repo using your GitHub access (`gh auth login` and
      `gh auth setup-git` if needed). A checklist inside cruxcode then walks you
      through signing in to Claude and Jev; `/cruxcode-help` shows how to use it.

      `cruxcode update` pulls the latest harness; `brew upgrade cruxcode` updates pi.
      Settings and sign-ins live in ~/.pi/agent (not touched by brew).
    EOS
  end

  test do
    assert_match "cruxcode #{version} (pi 1.2.0)", shell_output("#{bin}/cruxcode --version")
  end
end
