# Crux Digital tools

```sh
brew install cruxdigital-llc/tools/shunter
brew install cruxdigital-llc/tools/cruxcode
```

## shunter

Plans coding tasks with a strong model, uses TypeSafe Jev to judge what each task needs, and has the cheapest capable model on OpenRouter implement it.

```sh
shunter            # start in any project; the first run walks you through adding your API keys
shunter setup      # add or change API keys (stored in ~/.config/shunter, readable only by you)
shunter config     # see which kinds of work go to which models
shunter mcp        # use it from Claude Code or another MCP client
```

You'll need a [TypeSafe](https://console.typesafe.ai) API key and an [OpenRouter](https://openrouter.ai/keys) API key.

Upgrade with `brew upgrade shunter`. Binaries for macOS (Apple Silicon, Intel) and Linux (arm64, x64) are attached to each [release](../../releases).

## cruxcode

Crux Digital's coding harness: [pi](https://pi.dev) with GLaDOS workflows run automatically and TypeSafe Jev making the quick judgments. Describe the work; bugs, features and reviews run through GLaDOS on a frontier Claude model.

```sh
cruxcode             # start in any repo; the first run fetches the harness with your GitHub access
cruxcode update      # pull the latest harness
```

Inside cruxcode, sign in once with `/login anthropic` (your Claude account) and `/login openrouter` (Jev), then check with `/cruxcode-setup`. The harness itself lives in the private [cruxdigital-llc/cruxcode](https://github.com/cruxdigital-llc/cruxcode) repo, so you need access to it (`gh auth login` and `gh auth setup-git`). `brew upgrade cruxcode` updates pi.
