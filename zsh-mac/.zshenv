typeset -U path
path=($HOME/.local/bin $path)

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(mise activate zsh --shims)"

if [[ -d /Applications/Ghostty.app/Contents/MacOS ]]; then
  path=(/Applications/Ghostty.app/Contents/MacOS $path)
fi
