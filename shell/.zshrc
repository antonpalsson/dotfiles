# Oh My Zsh
export PATH="$HOME/bin:/usr/local/bin:/opt/homebrew/bin:$PATH"

plugins=(git aliases autojump tmux asdf yarn docker docker-compose)

ZSH_THEME="pollele"

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Copy kitty terminfo to server
alias ssh="kitty +kitten ssh"

# Git shit
function gbda() { git branch | grep -v "master\|main\|develop\|\*" | xargs git branch -D } # Cleanup branches
function gcol() { git branch | grep -i -m 1 "$@" | xargs git checkout } # I'm feeling lucky checkout

# Nvim
alias n="nvim ."
