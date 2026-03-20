typeset -U path
path=($HOME/.local/bin $path)

eval "$(mise activate zsh --shims)"

export EDITOR="nvim"
export VISUAL="nvim"
