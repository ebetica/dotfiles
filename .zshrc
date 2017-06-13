source /etc/profile

# Oh My ZSH config

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="ebetica"
plugins=(git archlinux aws brew common-aliases docker gitfast mercurial lwd pip 
  sudo vi-mode web-search)

source $ZSH/oh-my-zsh.sh

# User Configeration

export EDITOR='vim'

alias -g X='| xargs -n 1 -I %'
fortune
