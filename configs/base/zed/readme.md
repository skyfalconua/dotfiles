### shell

```sh
# use brew or npm

# Microsoft
brew install copilot-cli
npm install -g @github/copilot

# Google
brew install gemini-cli
npm install -g @google/gemini-cli

# Anthropic
brew install claude-code
npm install -g @anthropic-ai/claude-code

# OpenAI
brew install codex
npm install -g @openai/codex

# Anomaly Innovations Inc
brew install opencode
npm install -g opencode-ai
```

### zed actions
```
agent: open settings
```

### misc
```
  delta settings -sfv $HOME/.config/zed/settings.json

  // .config/zed/tasks.json
  {
    "label": "tv::Files",

    // "command": "zed \"$(tv files --no-status-bar)\"",
    // "command": "zed \"$(tv text --no-status-bar)\"",

    // "command": "cd $ZED_DIRNAME && gitui",
    // "hide": "on_success",

    "allow_concurrent_runs": true,
    "use_new_terminal": true
  },

  // .config/zed/keymap.json
  {
    "bindings": {
      ...
      "cmd-alt-p": [
        "task::Spawn",
        { "task_name": "tv::Files", "reveal_target": "center" },
      ]
    }
  },
```
