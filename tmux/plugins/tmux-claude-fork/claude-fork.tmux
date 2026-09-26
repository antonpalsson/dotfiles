#!/usr/bin/env sh
# Entry point. Sourced by tmux at startup, by TPM or by a run-shell line.

CURRENT_DIR=$(cd "$(dirname "$0")" && pwd)
SCRIPT="$CURRENT_DIR/scripts/claude-fork.sh"

[ -x "$SCRIPT" ] || chmod +x "$SCRIPT" 2>/dev/null

key=$(tmux show-option -gqv @claude_fork_key)
tmux bind-key "${key:-F}" run-shell "$SCRIPT '#{pane_id}'"
