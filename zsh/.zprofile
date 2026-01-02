typeset -U path
path=($HOME/.local/bin $path)

if [[ -d /Applications/Ghostty.app/Contents/MacOS ]]; then
  path=(/Applications/Ghostty.app/Contents/MacOS $path)
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(mise activate zsh --shims)"
