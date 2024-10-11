# Paths
typeset -U path
path+=($HOME '/bin' '/usr/local/bin')

# Prompt (Nix shell)
setopt prompt_subst
PROMPT='%B%F{green}%n@%m%f%b %F{yellow}${IN_NIX_SHELL:+[nix-shell] }%f%F{blue}%~%f %# '

# Nix
function nixrebuild() { darwin-rebuild switch --flake "$@" }
alias nix-shell="nix-shell --run zsh"

# CLI apps
eval "$(z --init zsh)" # Z fast nagivgate
eval "$(mise activate zsh)" # Mise RVM
eval "$(/opt/homebrew/bin/brew shellenv)" # Homebrew

# Env vars
export EDITOR="nvim"
export VISUAL="nvim"

# Alaises
alias ll="ls -la"

alias sa="source ~/.zshrc"
alias vim="nvim"

alias dc="docker compose"
alias dce="docker compose exec"

alias gss="git status --short"
alias gd="git diff"
alias gll="git log"
alias glg="git log --stat"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit"
alias gcmsg="git commit --message"
alias gc!="git commit --amend"
alias gcn!="git commit --amend --no-edit"
alias gb="git branch"
alias gco="git checkout"
alias grb="git rebase"
alias grbi="git rebase --interactive"
alias gpf="git push --force-with-lease"
alias gp="git push"
alias gl="git pull"
alias gf="git fetch"
function gpsup() { git branch --show-current | xargs git push --set-upstream origin } # Set upstream
function gcm() { git branch --format "%(refname:short)" | grep "master\|main" | head -1 | xargs git checkout } # Checkout master/main
function gcol() { git branch --format "%(refname:short)" | grep -i -m 1 "$@" | xargs git checkout } # I'm feeling lucky checkout
function gbda() { git branch | grep -v "master\|main\|develop\|\*" | xargs git branch -D } # Cleanup branches

# Bind delete
bindkey "^[[3~" delete-char

# Kosläpp
# ((RANDOM % 12 == 0)) && echo Mooooooo | cowsay && echo ""

