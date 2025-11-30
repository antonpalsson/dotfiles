# Paths
typeset -U path
path=(
  /Users/polle/.local/share/mise/shims
  /opt/homebrew/bin
  /usr/bin
  /usr/sbin
  /bin
  /sbin
)

# Prompt
PROMPT='%B%F{green}%n@%m%f%b %f%F{blue}%~%f %# '

# CLI apps
eval "$(mise activate --shims)" # Mise
eval "$(zoxide init zsh)" # Zoxide

# Env vars
export DOTS="/Users/polle/Github/antonpalsson/dotfiles"
export RIPGREP_CONFIG_PATH="$DOTS/.ripgreprc"
export EDITOR="nvim"

# Aliases
alias ".."="cd .."
alias "..."="cd ../.."
alias "...."="cd ../../.."
alias ll="ls -la"
alias sa="source ~/.zshrc"

alias icat="kitten icat"
alias k="kubectl"
alias lazygit="lazygit"
alias lazydocker="lazydocker"

alias vim="nvim"

alias ta="tmux attach"
alias tl="tmux list-sessions"
function ts() { tmux new -s "$*" }

alias dc="docker compose"
alias dce="docker compose exec"
alias dcr="docker compose run --rm"
alias dcdu="docker compose down && docker compose up -d"
function dcl() { docker compose logs "$@" -f }
function dcb() { docker compose exec "$@" bash }

alias gss="git status --short"
alias gd="git diff"
alias glg="git log --stat"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit"
alias gcmsg="git commit --message"
alias gc!="git commit --amend"
alias gcn!="git commit --amend --no-edit"
alias gcp="git cherry-pick"
alias gcpa="git cherry-pick --abort"
alias gcpc="git cherry-pick --continue"
alias gb="git branch"
alias gco="git checkout"
alias grbi="git rebase --interactive"
alias grba="git rebase --abort"
alias grbc="git rebase --continue"
alias gl="git pull"
alias gf="git fetch"
alias gp="git push"
alias gpf="git push --force-with-lease"
function gcm() { git branch --format "%(refname:short)" | grep "master\|main" | head -1 | xargs git checkout } # Checkout master/main
function gcol() { git branch --format "%(refname:short)" | grep -i -m 1 "$@" | xargs git checkout } # I'm feeling lucky checkout
function gbda() { git branch | grep -v "master\|main\|develop\|wip\|tmp\|temp\|\*" | xargs git branch -D } # Cleanup branches

# Booli
if [ -f ~/.booli_zshrc ]; then
    source ~/.booli_zshrc
fi
