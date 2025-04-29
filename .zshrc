# Paths
typeset -U path
path+=($HOME '/bin' '/usr/local/bin')
path+=($PATH '/Users/polle/.lmstudio/bin') # LM studio

# Prompt
PROMPT='%B%F{green}%n@%m%f%b %f%F{blue}%~%f %# '

# CLI apps
eval "$(/opt/homebrew/bin/brew shellenv)" # Homebrew
eval "$(mise activate zsh)" # Mise RVM
eval "$(zoxide init zsh)" # Zoxide
source <(fzf --zsh) # FZF

# Env vars
export DOTS="/Users/polle/Github/antonpalsson/dotfiles"
export RIPGREP_CONFIG_PATH="$DOTS/.ripgreprc"
export EDITOR="nvim"
export VISUAL="nvim"

# Aliases
alias sa="source ~/.zshrc"
alias ".."="cd .."
alias ll="ls -la"
alias icat="kitten icat"

alias vim="nvim"
alias v="nvim"

alias ta="tmux attach"
alias tl="tmux list-sessions"
function ts() { tmux new -s "$*" }

alias dc="docker compose"
alias dce="docker compose exec"
alias dcdu="docker compose down && docker compose up -d"
function dcl() { docker compose logs "$@" -f }
function dcb() { docker compose exec "$@" bash }

alias k="kubectl"

alias gss="git status --short"
alias gd="git diff"
alias gll="git log"
alias glg="git log --stat"
alias ga="git add"
alias gaa="git add --all"
alias gap="git add --patch"
alias gc="git commit"
alias gcmsg="git commit --message"
alias gc!="git commit --amend"
alias gcn!="git commit --amend --no-edit"
alias gcp="git cherry-pick"
alias gcpa="git cherry-pick --abort"
alias gcpc="git cherry-pick --continue"
alias gb="git branch"
alias gco="git checkout"
alias grb="git rebase"
alias grbi="git rebase --interactive"
alias grba="git rebase --abort"
alias grbc="git rebase --continue"
alias gl="git pull"
alias gf="git fetch"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpf!="git push --force"
function gpsup() { git branch --show-current | xargs git push --set-upstream origin } # Set upstream
function gcm() { git branch --format "%(refname:short)" | grep "master\|main" | head -1 | xargs git checkout } # Checkout master/main
function gcol() { git branch --format "%(refname:short)" | grep -i -m 1 "$@" | xargs git checkout } # I'm feeling lucky checkout
function gbda() { git branch | grep -v "master\|main\|develop\|wip\|tmp\|temp\|\*" | xargs git branch -D } # Cleanup branches

alias lgit="lazygit"

function auto() {
    local retries=0
    local max_retries=20
    local delay=1

    while (( retries < max_retries )); do
        "$@" && retries=0 || (( retries++ ))

        if (( retries < max_retries )); then
            sleep $delay
            echo "Retrying ..."
        else
            echo "Max retries ($max_retries) reached. Giving up."
        fi
    done
}

# Booli
if [ -f ~/.booli_zshrc ]; then
    source ~/.booli_zshrc
else
    print "~/.booli_zshrc not found."
fi

# Kosläpp
# ((RANDOM % 12 == 0)) && echo Mooooooo | cowsay && echo ""
