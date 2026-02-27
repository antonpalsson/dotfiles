# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;31m\](π)\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \$ '

# History
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend

# Check window size after each command
shopt -s checkwinsize

# Env vars
export MINIMAL_NVIM=1
export EDITOR="nvim"
export VISUAL="nvim"
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Color aliases
alias ".."='cd ..'
alias ll='ls -la'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
