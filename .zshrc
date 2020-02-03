source /etc/profile

# Oh My ZSH config

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="ebetica"
plugins=(git archlinux aws brew common-aliases docker gitfast mercurial lwd pip 
  sudo vi-mode web-search history-substring-search zsh-syntax-highlighting fzf z)

source $ZSH/oh-my-zsh.sh

setopt hist_ignore_all_dups

# User Configeration
export PATH=$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH

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
bindkey "^[[3~" 	delete-char

unset zle_bracketed_paste

export EDITOR='kak'

alias -g X='| xargs -n 1 -I %'
alias googler='BROWSER=lynx googler'

eval `keychain --eval --agents ssh id_rsa`

fortune
