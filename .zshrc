source /etc/profile

# Oh My ZSH config

export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM="$(dirname ${(%):-%x})/zsh_custom"
ZSH_THEME="ebetica"
plugins=(
# These plugins conflict, do it in this order
vi-mode git
# make sure vi-mode is first
archlinux cargo colored-man-pages common-aliases dirhistory docker fd
fzf fzf-z gem git-auto-fetch gitfast github history-substring-search
last-working-dir mercurial mosh npm pip ripgrep rsync rust sudo tmux
ubuntu web-search z zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
fpath=("$ZSH_CUSTOM/completions" $fpath)
autoload -U compinit && compinit

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
if hash hub; then alias git='hub'; fi

alias -g X='| xargs -n 1 -I %'
alias googler='BROWSER=lynx googler'

eval `keychain --eval --agents ssh id_rsa`

fortune
