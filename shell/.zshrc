# Oh My Zsh
export PATH="$HOME/bin:/usr/local/bin:/opt/homebrew/bin:$PATH"

plugins=(git aliases autojump fzf tmux asdf yarn docker docker-compose)

ZSH_THEME="pollele"

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# SSH in 1pass
export SSH_AUTH_SOCK="~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Copy kitty terminfo to server
alias ssh="kitty +kitten ssh"

alias vim="nvim"

# Git shit
function gbda() { git branch | grep -v "master\|main\|develop\|\*" | xargs git branch -D } # Cleanup branches
function gcol() { git branch | grep -i -m 1 "$@" | xargs git checkout } # I'm feeling lucky checkout

