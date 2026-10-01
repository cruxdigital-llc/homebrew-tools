# shunter

```sh
brew install cruxdigital-llc/shunter/shunter
shunter            # first run walks you through adding your API keys
```

## shunter

Plans coding tasks with a strong model, uses TypeSafe Jev to judge what each task needs, and has the cheapest capable model on OpenRouter implement it.

- `shunter` interactive session in the current project
- `shunter setup` add or change API keys (stored in `~/.config/shunter`, readable only by you)
- `shunter config` see which kinds of work go to which models
- `shunter mcp` use it from Claude Code or another MCP client

You'll need a [TypeSafe](https://console.typesafe.ai) API key and an [OpenRouter](https://openrouter.ai/keys) API key.

Upgrade with `brew upgrade shunter`. Binaries for macOS (Apple Silicon, Intel) and Linux (arm64, x64) are attached to each [release](../../releases).
