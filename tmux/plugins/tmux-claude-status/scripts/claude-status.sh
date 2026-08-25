#!/usr/bin/env sh
# Reports Claude Code session state into tmux options.
#
#   claude-status.sh busy|wait|idle|off   called from Claude Code hooks
#   claude-status.sh sweep                called from status-right on every
#                                         status-interval tick
#
# State is owned by the pane, so two Claudes sharing a window cannot overwrite
# each other's dot and the state dies with the pane:
#   @claude_pane_state   busy | wait | idle
#   @claude_pane_dir     basename of the project dir
#
# Everything else is derived from those on every event:
#   @claude_window_dots (window)  one coloured dot per Claude-running pane, in
#                                 pane order, for the status bar
#   @claude_dots        (session) the session's windows' dots joined, for the
#                                 choose-tree session overview
#   @claude_sessions    (global)  every session with a Claude in it, as its name
#                                 (or, with @claude_session_label index, just the
#                                 number that name starts with) followed by that
#                                 session's dots, for a one-line overview of the
#                                 whole server
#
# Every level carries its own option name on purpose: tmux resolves @options
# pane-first, then window, then session, so a shared name at a narrower level
# would shadow the wider one everywhere a format is drawn.
#
# The sweep is the stale-state safety net, and it covers two failures the hooks
# cannot see. Both are described where they are handled, in sweep() below.

command -v tmux >/dev/null 2>&1 || exit 0

state=$1

# Everything except the sweep acts on the pane that called it.
[ "$state" = sweep ] || [ -n "$TMUX_PANE" ] || exit 0

# The palette the entry script installed, resolved once per run and reused by
# every window refreshed after. The ANSI fallbacks only matter if it has not
# run yet.
glyph=''
palette() {
  [ -z "$glyph" ] || return 0

  colors=$(tmux display-message -p \
    '#{@claude_color_busy}:#{@claude_color_wait}:#{@claude_color_idle}' 2>/dev/null)
  c_busy=${colors%%:*}
  colors=${colors#*:}
  c_wait=${colors%%:*}
  c_idle=${colors##*:}
  : "${c_busy:=yellow}" "${c_wait:=red}" "${c_idle:=green}"

  glyph=$(tmux show-option -gqv @claude_glyph)
  : "${glyph:= ●}"
}

# One coloured glyph for a pane state, appended to the $dots being built. A
# pane with no state is a pane with no Claude, and adds nothing.
add_dot() {
  case $1 in
    busy) dots="$dots#[fg=$c_busy]$glyph" ;;
    wait) dots="$dots#[fg=$c_wait]$glyph" ;;
    idle) dots="$dots#[fg=$c_idle]$glyph" ;;
  esac
}

# Write the $dots just built for a window, or clear the window when they came
# out empty: the last Claude there is gone, so the name is tmux's again.
store_window_dots() {
  win=$1
  if [ -n "$dots" ]; then
    tmux set-option -t "$win" -w @claude_window_dots "$dots" 2>/dev/null
  else
    tmux set-option -t "$win" -uw @claude_window_dots 2>/dev/null
    [ "$(tmux show-option -gqv @claude_rename_window)" = off ] ||
      tmux set-option -t "$win" -w automatic-rename on 2>/dev/null
  fi
}

# One dot per Claude-running pane, in pane order, so two Claudes split across
# one window get a dot each rather than one dot between them.
refresh_window() {
  palette
  dots=''
  for s in $(tmux list-panes -t "$1" -F '#{@claude_pane_state}' 2>/dev/null); do
    add_dot "$s"
  done
  store_window_dots "$1"
}

# One window of a whole-server pass. A window with no Claude in it is only
# cleared if it was carrying dots ($had), so a window you renamed yourself is
# never handed back to automatic-rename.
flush_window() {
  [ -n "$dots" ] || case $had in
    *" $1 "*) ;;
    *) return 0 ;;
  esac
  store_window_dots "$1"
}

# Every window at once, from a single pass over every pane on the server. The
# sweep rebuilds this way rather than calling refresh_window per window: a
# pane can be joined into a different window, and a config reload can leave a
# window whose dots were never built at all, and neither shows up as a stale
# pane.
refresh_windows() {
  palette

  # Which windows carry dots now, folded onto one space-separated line so
  # membership is a glob rather than a show-option per window.
  had=" $(tmux list-windows -a -F '#{?@claude_window_dots,#{window_id},}' 2>/dev/null |
    tr '\n' ' ')"

  cur=''
  dots=''
  while read -r wid pane_state; do
    if [ "$wid" != "$cur" ]; then
      [ -z "$cur" ] || flush_window "$cur"
      cur=$wid
      dots=''
    fi
    add_dot "$pane_state"
  done <<EOF
$(tmux list-panes -a -F '#{window_id} #{@claude_pane_state}' 2>/dev/null)
EOF
  [ -z "$cur" ] || flush_window "$cur"
}

# The session's windows' dots, in window order. Read a line at a time rather
# than word-split: a window's dots are one string containing spaces.
refresh_session() {
  sess=$1

  dots=''
  while IFS= read -r wd; do
    dots="$dots$wd"
  done <<EOF
$(tmux list-windows -t "$sess" -F '#{@claude_window_dots}' 2>/dev/null)
EOF

  if [ -n "$dots" ]; then
    tmux set-option -t "$sess" @claude_dots "$dots#[default]" 2>/dev/null
  else
    tmux set-option -t "$sess" -u @claude_dots 2>/dev/null
  fi
}

# One line for the whole server: every session that has a Claude in it, named,
# with that session's dots after it. "dots ● | next ● ●". Built from the session
# dots rather than from the panes again, so it is only ever as fresh as the
# refresh_session call that preceded it.
#
# The name of the session the line is being drawn for is wrapped in a format
# conditional rather than coloured here: the option is one string shared by
# every client, so "which session is mine" can only be decided at draw time.
refresh_global() {
  sep=$(tmux show-option -gqv @claude_sep)
  : "${sep:= | }"
  c_cur=$(tmux show-option -gqv @claude_color_current)
  label_style=$(tmux show-option -gqv @claude_session_label)

  tab=$(printf '\t')
  line=''
  while IFS="$tab" read -r name dots; do
    [ -n "$dots" ] || continue

    # tmux gives sessions no index of their own, so the index is the number
    # the name starts with — the ordering prefix in names like "2 next".
    # A name that does not start with one has no index to show, so it is
    # drawn whole.
    text=$name
    if [ "$label_style" = index ]; then
      digits=${name%%[!0-9]*}
      [ -z "$digits" ] || text=$digits
    fi

    # The comparison still has to be against the whole name, whatever is drawn.
    label=$text
    if [ -n "$c_cur" ]; then
      case $name in
        # A name a format cannot safely compare against goes in unhighlighted.
        *','* | *'#'* | *'{'* | *'}'*) ;;
        *) label="#{?#{==:#{session_name},$name},#[fg=$c_cur],#[default]}$text" ;;
      esac
    fi

    # Every entry ends in #[default], so the separator needs no colour of its
    # own to come out unstyled.
    [ -z "$line" ] || line="$line$sep"
    line="$line$label$dots"
  done <<EOF
$(tmux list-sessions -F "#{session_name}${tab}#{@claude_dots}" 2>/dev/null)
EOF

  if [ -n "$line" ]; then
    tmux set-option -g @claude_sessions "$line#[default]" 2>/dev/null
  else
    tmux set-option -g -u @claude_sessions 2>/dev/null
  fi
}

refresh_all() {
  ids=$(tmux display-message -p -t "$TMUX_PANE" '#{window_id} #{session_id}' 2>/dev/null)
  [ -n "$ids" ] || exit 0
  refresh_window "${ids% *}"
  refresh_session "${ids#* }"
  refresh_global
  tmux refresh-client -S 2>/dev/null
}

# A pane whose foreground process is a shell is a pane where Claude is no
# longer running. Resolved once per sweep, not once per pane.
shells=''
is_shell() {
  for s in $shells; do
    [ "$1" = "$s" ] && return 0
  done
  return 1
}

# Two things can leave a pane showing a state that is no longer true, and
# neither of them fires a hook. The sweep is what notices, on every
# status-interval tick.
#
# 1. Claude is gone but its dot is not. Quit, Ctrl-C at the prompt, a crash, a
#    SIGKILL: SessionEnd never runs for any of those, so nothing clears the
#    pane. But the pane is back at a shell prompt, which is visible from the
#    outside as pane_current_command, so clear it whatever killed Claude.
#
# 2. Claude is still running but stopped working. Ctrl-C ends a turn without
#    any hook at all — Stop is skipped on a user interrupt — so the pane would
#    sit on busy until the next turn starts. A running turn is the only thing
#    that offers "esc to interrupt" in the footer, so a busy pane no longer
#    showing it is a pane that stopped: demote it to idle. Only busy panes are
#    looked at, so a permission prompt (wait) is never touched.
sweep() {
  shells=$(tmux show-option -gqv @claude_shells)
  : "${shells:=sh bash zsh fish dash ksh csh tcsh nu}"

  # All the pane writes happen here, in one pass, before any window is
  # refreshed: two panes can share a window. What comes out is only a marker
  # that something changed, for the redraw at the end.
  stale=$(tmux list-panes -a \
    -F '#{pane_id} #{window_id} #{pane_current_command} #{@claude_pane_state}' 2>/dev/null |
    while read -r pane win cmd pane_state; do
      [ -n "$pane_state" ] || continue

      if is_shell "$cmd"; then
        tmux set-option -p -t "$pane" -u @claude_pane_state 2>/dev/null
        tmux set-option -p -t "$pane" -u @claude_pane_dir 2>/dev/null
        echo "$win"
      elif [ "$pane_state" = busy ] &&
        ! tmux capture-pane -p -t "$pane" 2>/dev/null |
          tail -4 | grep -q 'esc to interrupt'; then
        tmux set-option -p -t "$pane" @claude_pane_state idle 2>/dev/null
        echo "$win"
      fi
    done)

  # Window and session dots are recomputed every tick regardless of what the
  # pass above found: a killed window takes its dots with it, and a pane can
  # move between windows, neither of which is a stale pane.
  refresh_windows


  for sess in $(tmux list-sessions -F '#{session_id}' 2>/dev/null); do
    refresh_session "$sess"
  done
  refresh_global

  [ -n "$stale" ] && tmux refresh-client -S 2>/dev/null
  return 0
}

case "$state" in
  sweep)
    sweep
    ;;
  # "clear" is what the sweep took over. It is still accepted so it can be
  # driven from a shell prompt hook instead, for a dot that clears on the
  # keystroke rather than on the next tick.
  clear | off)
    tmux set-option -p -t "$TMUX_PANE" -u @claude_pane_state 2>/dev/null
    tmux set-option -p -t "$TMUX_PANE" -u @claude_pane_dir 2>/dev/null
    refresh_all
    ;;
  busy | wait | idle)
    # The Notification hook fires both for permission prompts and for the
    # "waiting for your input" reminder ~60s after the prompt goes idle. Only
    # the first is worth flagging, and it can only happen mid-turn, where
    # PreToolUse has already set busy. So wait is a busy-only transition;
    # a wait arriving from any other state is the idle reminder, ignore it.
    if [ "$state" = "wait" ]; then
      current=$(tmux display-message -p -t "$TMUX_PANE" '#{@claude_pane_state}' 2>/dev/null)
      [ "$current" = "busy" ] || exit 0
    fi

    # The hooks all pass CLAUDE_PROJECT_DIR. Falling back to the dir already
    # recorded for the pane keeps the name stable if one ever does not; $PWD is
    # the last resort, and only right for a hook run from the project root.
    if [ -n "$CLAUDE_PROJECT_DIR" ]; then
      dir=$(basename "$CLAUDE_PROJECT_DIR")
    else
      dir=$(tmux display-message -p -t "$TMUX_PANE" '#{@claude_pane_dir}' 2>/dev/null)
      : "${dir:=$(basename "$PWD")}"
    fi

    tmux set-option -p -t "$TMUX_PANE" @claude_pane_state "$state" 2>/dev/null
    tmux set-option -p -t "$TMUX_PANE" @claude_pane_dir "$dir" 2>/dev/null
    [ "$(tmux show-option -gqv @claude_rename_window)" = off ] ||
      tmux rename-window -t "$TMUX_PANE" "$dir" 2>/dev/null
    refresh_all
    ;;
esac

exit 0
