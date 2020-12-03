# Exports Oh My Zsh
export ZSH="/Users/polle/.oh-my-zsh"
# Exports AWS
export AWS_PROFILE=fishbrain
export DEFAULT_AWS_REGION=eu-west-1
# Exports NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# Exports Paths
export PATH=/usr/local/bin:$PATH
export PATH="/usr/local/opt/terraform@0.12/bin:$PATH"

# Exports Vim fzf search
# Pipe through ag to respect .gitignore
export FZF_DEFAULT_COMMAND='ag -g ""'

# Plugins
plugins=(
  zsh-autosuggestions
)

# Theme
ZSH_THEME="hajen"

# Direnv
eval "$(direnv hook zsh)"

source $ZSH/oh-my-zsh.sh

# Alias
alias c='clear'
alias dc='docker-compose'
alias v='vim'
alias t='tmux'
alias g='git'
