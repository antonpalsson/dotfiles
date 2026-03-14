typeset -U path
path=($HOME/.local/bin $path)

eval "$(mise activate zsh --shims)"

if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec Hyprland
fi
