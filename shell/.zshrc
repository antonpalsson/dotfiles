# Paths
typeset -U path
path+=($HOME '/bin' '/usr/local/bin')

# Oh My Zsh
ZSH_THEME="pollele"
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# DOT
export DOT="$HOME/Github/antonpalsson/dotfiles"

# Homebrew
path+=('/opt/homebrew/bin')
eval "$(/opt/homebrew/bin/brew shellenv)"

# Zoxide
eval "$(zoxide init zsh)"

# Asdf
source "/opt/homebrew/opt/asdf/libexec/asdf.sh"

# Fzf
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"

# Copy kitty terminfo to server
alias ssh="kitty +kitten ssh"

# Aliases shit
alias vim="nvim"

alias dc="docker compose"
alias dce="docker compose exec"
alias dcr="docker compose down && docker compose up --detach"

alias gss="git status --short"
alias gd="git diff"
alias glg="git log --stat"
alias gaa="git add --all"
alias gc="git commit"
alias gc!="git commit --amend"
alias gcn!="git commit --amend --no-edit"
alias gb="git branch"
alias gco="git checkout"
alias gpf="git push --force-with-lease"
alias gp="git push"
alias gl="git pull"
function gbda() { git branch | grep -v "master\|main\|develop\|\*" | xargs git branch -D } # Cleanup branches
function gcol() { git branch | grep -i -m 1 "$@" | xargs git checkout } # I'm feeling lucky checkout

