# tmux-claude-status

A coloured dot in the tmux status bar for every Claude Code running.

```
 1:dotfiles ●   2:api ● ●   3:web ●
```

- 🟢 **idle** — finished, waiting for your next prompt
- 🟡 **busy** — working
- 🔴 **wait** — blocked on a permission prompt, needs you now

The dots also show up per session — on one line for the whole server, and in
`choose-tree` — so you can see which sessions have a Claude wanting attention
without visiting them:

```
 dotfiles ●   api ● ●
```

State lives on the **pane**, not the window, so two Claudes in a split cannot
overwrite each other's dot: a window draws one dot per pane running Claude, in
pane order, and a session's dots are its windows' dots in window order.

Requires tmux 3.2 or newer (for the `#{E:}` and `#{==:}` formats). Developed
against 3.7.

## Install

Part of this dotfiles repo: `./install` stows it to
`~/.config/tmux/plugins/tmux-claude-status`, and the last line of
`tmux/tmux.conf` loads it:

```tmux
run-shell ~/.config/tmux/plugins/tmux-claude-status/claude-status.tmux
```

That line has to come **last**, after the status formats — the plugin reads
them to place the dot.

Nothing here is specific to this repo, so it also works standalone: drop the
directory anywhere and use the same `run-shell` line, or point
[TPM](https://github.com/tmux-plugins/tpm) at it with
`set -g @plugin '<user>/tmux-claude-status'`.

Either way the Claude Code hooks below are what actually set the state. Without
them you get no dots.

## Claude Code hooks

The tmux side cannot see Claude; Claude has to report in. Merge this into
`~/.claude/settings.json`, fixing the path to wherever you cloned the plugin:

```json
{
  "hooks": {
    "SessionStart": [
      { "hooks": [{ "type": "command", "command": "~/.config/tmux/plugins/tmux-claude-status/scripts/claude-status.sh idle" }] }
    ],
    "UserPromptSubmit": [
      { "hooks": [{ "type": "command", "command": "~/.config/tmux/plugins/tmux-claude-status/scripts/claude-status.sh busy" }] }
    ],
    "PreToolUse": [
      { "hooks": [{ "type": "command", "command": "~/.config/tmux/plugins/tmux-claude-status/scripts/claude-status.sh busy" }] }
    ],
    "PostToolUse": [
      { "hooks": [{ "type": "command", "command": "~/.config/tmux/plugins/tmux-claude-status/scripts/claude-status.sh busy" }] }
    ],
    "Notification": [
      { "hooks": [{ "type": "command", "command": "~/.config/tmux/plugins/tmux-claude-status/scripts/claude-status.sh wait" }] }
    ],
    "Stop": [
      { "hooks": [{ "type": "command", "command": "~/.config/tmux/plugins/tmux-claude-status/scripts/claude-status.sh idle" }] }
    ],
    "SessionEnd": [
      { "hooks": [{ "type": "command", "command": "~/.config/tmux/plugins/tmux-claude-status/scripts/claude-status.sh off" }] }
    ]
  }
}
```

`Notification` fires both for permission prompts and for the "waiting for your
input" reminder a minute after the prompt goes idle. Only the first is worth
flagging, so `wait` is treated as a busy-only transition and a `wait` arriving
from any other state is dropped.

## Where the dot goes

By default the plugin appends the dot to your window names. To put it somewhere
else, write `#{claude_dot}` into any of `window-status-format`,
`window-status-current-format`, `status-left` or `status-right` and the plugin
uses your placement instead:

```tmux
set -g window-status-format ' #I:#W#{claude_dot} '
set -g window-status-current-format '#[fg=white] #I:#W#{claude_dot} '
```

## The all-sessions line

`#{claude_sessions}` is the whole server on one line: every session that has a
Claude in it, named, with that session's dots after it, sessions joined by
`@claude_sep`. Sessions with no Claude are left out, and the line is empty when
no session has one. Put it wherever a status format goes — top left, say:

```tmux
set -g status-left ' #{claude_sessions}'
set -g status-left-length 80
```

`status-left` is 10 columns wide by default, which truncates the line; the
plugin widens it to 80 if you have not set it yourself. The name of the session
you are looking at is drawn in `@claude_color_current` so it stands out from
the others.

If your session names carry an ordering number — `0 dots`, `1 api`, `2 web` —
that number is all the line needs. `@claude_session_label index` draws it
alone, so the whole server fits in a few columns:

```tmux
set -g @claude_session_label 'index'
```

```
 0 ●   2 ● ●
```

tmux gives sessions no index of its own, so the index is the number the name
starts with; a session whose name does not start with one is still drawn in
full.

For the session overview in `choose-tree`, point it at the format the plugin
builds — tmux's own default with the dots added:

```tmux
bind s choose-tree -sZ -O name -F '#{E:@claude_tree_format}'
```

## Options

| Option | Default | |
|---|---|---|
| `@claude_color_idle` | `green` | finished |
| `@claude_color_busy` | `yellow` | working |
| `@claude_color_wait` | `red` | blocked on a prompt |
| `@claude_glyph` | `' ●'` | the mark itself, leading space included |
| `@claude_color_current` | `white` | the current session's name in the all-sessions line; empty to leave it unstyled |
| `@claude_sep` | `' \| '` | between sessions in the all-sessions line |
| `@claude_session_label` | `name` | how a session is labelled in the all-sessions line; `index` draws only the number its name starts with |
| `@claude_rename_window` | `on` | rename the window to the project dir while Claude runs |
| `@claude_auto_inject` | `on` | append the dot to window names when `#{claude_dot}` appears nowhere |
| `@claude_shells` | `sh bash zsh fish dash ksh csh tcsh nu` | commands that mean "Claude is not running here" |

Set them before the plugin line:

```tmux
set -g @claude_color_busy '#e0af68'
set -g @claude_color_wait '#f7768e'
set -g @claude_color_idle '#9ece6a'
```

## How stale dots get cleaned up

Two things leave a dot that is no longer true, and neither fires a hook. A
sweep runs on every `status-interval` tick to catch both:

1. **Claude is gone but its dot is not.** Quit, Ctrl-C at the prompt, a crash,
   a `SIGKILL` — `SessionEnd` runs for none of those. But the pane is back at a
   shell prompt, and that is visible from outside as `pane_current_command`, so
   the dot clears whatever killed Claude. This is what `@claude_shells` is for;
   add to it if your shell is missing.
2. **Claude is still running but stopped working.** Ctrl-C ends a turn without
   any hook at all — `Stop` is skipped on a user interrupt — so a pane would
   sit on busy until the next turn started. A running turn is the only thing
   that shows "esc to interrupt" in the footer, so a busy pane no longer
   showing it gets demoted to idle. Only busy panes are examined, so a
   permission prompt is never cleared out from under you.

The sweep is hung off `status-right` (printing nothing) because a status format
is the only periodic callback tmux has. If your `status-interval` is `0` the
plugin sets it to `5`, since otherwise the sweep would never run.

If you would rather have case 1 clear on the keystroke than on the next tick,
`claude-status.sh clear` is still accepted and clears only its own pane. From a
zsh prompt hook:

```zsh
if [ -n "$TMUX" ]; then
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _claude_status_clear
  _claude_status_clear() { ~/.config/tmux/plugins/tmux-claude-status/scripts/claude-status.sh clear }
fi
```
