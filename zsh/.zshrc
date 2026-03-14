# Prompt
PROMPT='%B%F{green}%n@%m%f%b %f%F{blue}%~%f %# '

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt AUTO_CD

# Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Tools
eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"
source <(fzf --zsh)

# Aliases
alias sa="source $HOME/.config/zsh/.zshrc"
alias q="exit"
alias cls="clear"

alias ".."="cd .."
alias "..."="cd ../.."
alias "...."="cd ../../.."

alias ls="eza --group-directories-first"
alias ll="eza -la --group-directories-first"
alias t2="eza -a --tree --level=2"
alias t3="eza -a --tree --level=3"
alias t4="eza -a --tree --level=4"
alias tf="eza -a --tree"

alias v="nvim"
alias vim="nvim"
alias k="kubectl"
alias ldocker="lazydocker"
alias lgit="lazygit"

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
