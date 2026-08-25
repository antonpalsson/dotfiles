#!/usr/bin/env sh
# Entry point. Sourced by tmux at startup, by TPM or by a run-shell line.
#
# Everything here is idempotent: it runs again on every config reload, and it
# never overwrites an option the user has already set.

CURRENT_DIR=$(cd "$(dirname "$0")" && pwd)
SCRIPT="$CURRENT_DIR/scripts/claude-status.sh"

[ -x "$SCRIPT" ] || chmod +x "$SCRIPT" 2>/dev/null

# Only set an option the user has left alone.
set_default() {
  [ -n "$(tmux show-option -gqv "$1")" ] || tmux set-option -g "$1" "$2"
}

set_default @claude_color_busy yellow
set_default @claude_color_wait red
set_default @claude_color_idle green
set_default @claude_glyph ' ●'
set_default @claude_color_current white
set_default @claude_sep ' | '
set_default @claude_session_label name

# The dot itself: one per Claude-running pane in the window, already coloured
# by the script. Drawn as nothing at all when no pane there is running Claude.
tmux set-option -g @claude_dot '#{@claude_window_dots}#[default]'

# tmux's own choose-tree format with the window dot and the session dots added,
# for `bind s choose-tree -F '#{E:@claude_tree_format}'`.
tmux set-option -g @claude_tree_format \
  '#{?pane_format,#{?pane_marked,#[reverse],}#{?pane_floating_flag,#[italics],}#{pane_current_command}#{pane_flags}#{?#{&&:#{pane_title},#{!=:#{pane_title},#{host_short}}},: "#{pane_title}",},window_format,#{?window_marked_flag,#[reverse],}#{window_name}#{window_flags}#{?#{&&:#{==:#{window_panes},1},#{&&:#{pane_title},#{!=:#{pane_title},#{host_short}}}},: "#{pane_title}",}#{E:@claude_dot},#{session_windows} windows#{?session_grouped, (group #{session_group}: #{session_group_list}),}#{?session_attached, (attached),}#{@claude_dots}}'

# Substitute #{claude_dot} and #{claude_sessions} wherever the user placed them
# in their own formats.
interpolate() {
  value=$(tmux show-option -gqv "$1")
  new=$(printf '%s' "$value" |
    sed -e 's/#{claude_dot}/#{E:@claude_dot}/g' \
      -e 's/#{claude_sessions}/#{E:@claude_sessions}/g')
  [ "$new" != "$value" ] || return 1
  tmux set-option -g "$1" "$new"
}

# Only the window dot has a fallback placement, so only it decides `placed`.
placed=1
for opt in window-status-format window-status-current-format \
  status-left status-right; do
  case $(tmux show-option -gqv "$opt") in
    *'#{claude_dot}'*) placed=0 ;;
  esac
  interpolate "$opt"
done

# Nothing to hang the dot on, so append it to the window names. Set
# @claude_auto_inject 'off' to opt out and get no dot until you place one.
if [ "$placed" = 1 ] && [ "$(tmux show-option -gqv @claude_auto_inject)" != off ]; then
  for opt in window-status-format window-status-current-format; do
    tmux set-option -g "$opt" "$(tmux show-option -gqv "$opt")#{E:@claude_dot}"
  done
fi

# The sweep prints nothing. It sits in status-right purely to get a call on
# every status-interval tick, which is the only periodic hook tmux offers.
right=$(tmux show-option -gqv status-right)
case $right in
  *"claude-status.sh sweep"*) ;;
  *) tmux set-option -g status-right "#($SCRIPT sweep)$right" ;;
esac

# status-left is 10 columns by default, which is not enough for a line naming
# every session. Widen it, but only while it is still at that default.
case $(tmux show-option -gqv status-left) in
  *'@claude_sessions'*)
    [ "$(tmux show-option -gqv status-left-length)" != 10 ] ||
      tmux set-option -g status-left-length 80
    ;;
esac

# A zero interval means the sweep would never run.
[ "$(tmux show-option -gqv status-interval)" != 0 ] ||
  tmux set-option -g status-interval 5
