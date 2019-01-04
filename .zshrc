source /etc/profile

# Oh My ZSH config

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="ebetica"
plugins=(git archlinux aws brew common-aliases docker gitfast mercurial lwd pip 
  sudo vi-mode web-search history-substring-search zsh-syntax-highlighting fzf)

source $ZSH/oh-my-zsh.sh

# User Configeration

## history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey '^[[Z' reverse-menu-complete
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

unset zle_bracketed_paste

export EDITOR='kak'

alias -g X='| xargs -n 1 -I %'
fortune
