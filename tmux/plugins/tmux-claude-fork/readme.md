# tmux-claude-fork

Fork the Claude Code session in the current pane into a new window, running
`claude --resume <session-id> --fork-session`.

Default binding: `prefix + F`. Change it with:

```tmux
set -g @claude_fork_key 'F'
```

Requires `jq`. Reads `~/.claude/sessions/<pid>.json`, which is internal to
Claude Code and may change between versions.
