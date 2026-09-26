#!/usr/bin/env sh
# Fork the Claude session running in pane $1 into a new window.
#
# Claude writes ~/.claude/sessions/<pid>.json for every running process, with
# the session id and the tmux pane it lives in. That file is internal to
# Claude Code, not a documented API.

pane=$1
tab=$(printf '\t')

fail() {
  tmux display-message "claude-fork: $1"
  exit 0
}

command -v jq >/dev/null 2>&1 || fail "jq not found"

match=""
for f in "$HOME"/.claude/sessions/*.json; do
  [ -f "$f" ] || continue
  line=$(jq -r --arg p "$pane" \
    'select((.tmux // "") | endswith($p)) | "\(.pid)\t\(.sessionId)\t\(.cwd)"' \
    "$f" 2>/dev/null) || continue
  [ -n "$line" ] || continue
  IFS=$tab read -r pid sid cwd <<LINE
$line
LINE
  kill -0 "$pid" 2>/dev/null || continue
  match=1
  break
done

[ -n "$match" ] || fail "no Claude session found in pane $pane"

win=$(tmux new-window -P -F '#{pane_id}' -c "$cwd") || fail "could not open window"
[ -n "$win" ] || fail "could not open window"
tmux send-keys -t "$win" "claude --resume $sid --fork-session" Enter
