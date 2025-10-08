# prompt style and colors based on Steve Losh's Prose theme:
# http://github.com/sjl/oh-my-zsh/blob/master/themes/prose.zsh-theme
#
# vcs_info modifications from Bart Trojanowski's zsh prompt:
# http://www.jukie.net/bart/blog/pimping-out-zsh-prompt
#
# git untracked files modification from Brian Carper:
# http://briancarper.net/blog/570/git-info-in-your-zsh-prompt

export VIRTUAL_ENV_DISABLE_PROMPT=1

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('%F{blue}`basename $VIRTUAL_ENV`%f') '
}
PR_GIT_UPDATE=1
PR_LAST_UPDATE=0

setopt prompt_subst

autoload -U add-zsh-hook
autoload -Uz vcs_info
autoload -Uz async && async

#use extended color palette if available
if [[ $terminfo[colors] -ge 256 ]]; then
    turquoise="%F{81}"
    orange="%F{166}"
    purple="%F{135}"
    hotpink="%F{161}"
    limegreen="%F{118}"
else
    turquoise="%F{cyan}"
    orange="%F{yellow}"
    purple="%F{magenta}"
    hotpink="%F{red}"
    limegreen="%F{green}"
fi

# enable VCS systems you use
zstyle ':vcs_info:*' enable git svn

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
PR_RST="%f"
FMT_BRANCH="(%{$turquoise%}%b%u%c${PR_RST})"
FMT_ACTION="(%{$limegreen%}%a${PR_RST})"
FMT_UNSTAGED="%{$orange%}●"
FMT_STAGED="%{$limegreen%}●"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""


function steeef_preexec {
    case "$2" in
        *git*)
            PR_GIT_UPDATE=1
            ;;
        *hub*)
            PR_GIT_UPDATE=1
            ;;
        *svn*)
            PR_GIT_UPDATE=1
            ;;
    esac
}
add-zsh-hook preexec steeef_preexec

function steeef_chpwd {
    PR_GIT_UPDATE=1
    # Force immediate update when changing directories
    vcs_info_msg_0_=""
}
add-zsh-hook chpwd steeef_chpwd

function steeef_vcs_info_async {
    cd -q "$PWD"
    FMT_BRANCH="(%{$turquoise%}%b%u%c${PR_RST})"
    zstyle ':vcs_info:*:prompt:*' formats " ${FMT_BRANCH}"
    vcs_info 'prompt'
    echo $vcs_info_msg_0_
}

function steeef_vcs_info_done {
    local job=$1 code=$2 output=$3
    if [[ $code -eq 0 ]]; then
        vcs_info_msg_0_=$output
        zle && zle reset-prompt
    fi
}

function steeef_precmd {
    local current_time=$EPOCHSECONDS
    
    # Check if 30 seconds have passed since last update
    if [[ $((current_time - PR_LAST_UPDATE)) -ge 30 ]]; then
        PR_GIT_UPDATE=1
    fi
    
    if [[ -n "$PR_GIT_UPDATE" ]] ; then
        # Stop any existing worker to prevent conflicts
        async_stop_worker vcs_worker 2>/dev/null
        # Start async vcs_info job
        async_start_worker vcs_worker -n
        async_register_callback vcs_worker steeef_vcs_info_done
        async_job vcs_worker steeef_vcs_info_async
        PR_GIT_UPDATE=
        PR_LAST_UPDATE=$current_time
    fi
}
add-zsh-hook precmd steeef_precmd

PROMPT=$'${SINGULARITY_NAME:-"%{$purple%}%n${PR_RST}@%{$orange%}$(hostname -s)${PR_RST}"} %{$limegreen%}%~${PR_RST}$vcs_info_msg_0_$(virtualenv_info)$ '
