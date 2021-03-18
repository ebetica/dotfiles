source /etc/profile

# Oh My ZSH config

export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM="$(dirname ${(%):-%x})/zsh_custom"
ZSH_THEME="ebetica"
export _Z_MAX_SCORE=100000
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

setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
export HISTSIZE=1000000
export SAVEHIST=1000000

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

# fzf with fancy looking linewrap indicator
export FZF_CTRL_R_OPTS="--preview 'echo {} |sed -e \"s/^ *\([0-9]*\) *//\" -e \"s/^\\(.\\{,\$COLUMNS\\}\\).*$/\\1/\"; echo {} |sed -e \"s/^ *[0-9]* *//\" -e \"s/^.\\{,\$COLUMNS\\}//g\" -e \"s/.\\{1,\$((COLUMNS-2))\\}/⏎ &\\n/g\"' --preview-window down:5 --bind ?:toggle-preview"

unset zle_bracketed_paste

export EDITOR='kak'
export GIT_EDITOR='kak'
if command -v hub &> /dev/null; then alias git='hub'; fi

export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

alias -g X='| xargs -n 1 -I %'
alias googler='BROWSER=lynx googler'
alias icat='img2sixel'
alias pdr='pyscrun -mipdb -cc'
alias tcopy='tmux loadb -'
alias tpaste='tmux saveb -'
alias sq='squeue -u $USER -o "%.18i %.9P %.80j %.8u %.2t %.10M %.6D %R"'
unalias fd

eval `keychain --eval --agents ssh id_rsa`

fortune
