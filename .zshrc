# Theme
ZSH_THEME="pollele"

# Plugins
plugins=(
  git
  zsh-autosuggestions
)

# NVM 
# Don't autoload because it's slow, use loadnvm to load when needed
export NVM_DIR="$HOME/.nvm"
alias loadnvm='[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"'

# Direnv
eval "$(direnv hook zsh)"

# Load Oh My Zsh
export ZSH="/Users/polle/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Load Autojump
source /usr/local/share/autojump/autojump.zsh

# Alias
alias dc='docker compose'
alias v='nvim'
alias t='tmux'

# Remove all local branches except master, main and develop
alias gbda="git branch | grep -v 'master\|main\|develop\|\*' | xargs git branch -D"

