typeset -U path
path=($HOME/.local/bin $path)

if [[ $(uname) == "Darwin" ]]; then
  path=(/opt/homebrew/bin /opt/homebrew/sbin $path)

  if (( $+commands[brew] )); then
    eval "$(brew shellenv)"
  fi

  if [[ -d /Applications/Ghostty.app/Contents/MacOS ]]; then
    path=(/Applications/Ghostty.app/Contents/MacOS $path)
  fi
fi

if [[ $(uname) == "Linux" ]]; then
  export NPM_CONFIG_PREFIX=$HOME/.npm-global
  path=($NPM_CONFIG_PREFIX/bin $path)
fi

if (( $+commands[mise] )); then
  eval "$(mise activate zsh --shims)"
fi
