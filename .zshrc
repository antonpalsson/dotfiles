# Theme
ZSH_THEME="pollele"

# Plugins
plugins=(
  zsh-autosuggestions
)

# NVM (don't auto load nvm)
export NVM_DIR="$HOME/.nvm"
alias loadnvm='[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"'

# FZF in Vim
# Pipe through ag to respect .gitignore
export FZF_DEFAULT_COMMAND='ag -g ""'

# Direnv
eval "$(direnv hook zsh)"

# Load Oh My Zsh
export ZSH="/Users/polle/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Alias
alias c='clear'
alias dc='docker compose'
alias v='vim'
alias t='tmux'
alias g='git'

