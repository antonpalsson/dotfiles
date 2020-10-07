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

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
  git
  dotenv
  zsh-autosuggestions
)

# Dotenv file
ZSH_DOTENV_FILE=.dotenv

source $ZSH/oh-my-zsh.sh

# Alias
alias clc='clear'
alias dc='docker-compose'
