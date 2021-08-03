# ENVIRONMENT VARIABLES OF INTEREST:
#   FZF_SLURM_LOOKBACK=14 default number of days to look back by.
#
#
# The code at the top and the bottom of this file is the same as in completion.zsh.
# Refer to that file for explanation.
if 'zmodload' 'zsh/parameter' 2>'/dev/null' && (( ${+options} )); then
  __fzf_key_bindings_options="options=(${(j: :)${(kv)options[@]}})"
else
  () {
    __fzf_key_bindings_options="setopt"
    'local' '__fzf_opt'
    for __fzf_opt in "${(@)${(@f)$(set -o)}%% *}"; do
      if [[ -o "$__fzf_opt" ]]; then
        __fzf_key_bindings_options+=" -o $__fzf_opt"
      else
        __fzf_key_bindings_options+=" +o $__fzf_opt"
      fi
    done
  }
fi

'emulate' 'zsh' '-o' 'no_aliases'

{

[[ -o interactive ]] || return 0

# CTRL-S - get SLURM job stats
__slurm_stats() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item
  command sacct --starttime "now-${FZF_SLURM_LOOKBACK:-14}days" --format=JobID,Jobname,partition,state,time,alloctres,reqmem,nodelist,elapsed,end -p -X | \
  	column -nts\| | (head -1 && tail -n +2 | tac) | \
  	FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-e:toggle-all $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | \
        awk '{printf "%s ", $1}' | sed 's/_\[[^]]*\]//g'
  local ret=$?
  echo
  return $ret
}

__fzfcmd() {
  [ -n "$TMUX_PANE" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}

fzf-slurm-widget() {
  LBUFFER="${LBUFFER}$(__slurm_stats)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   fzf-slurm-widget
bindkey '^E' fzf-slurm-widget

} always {
  eval $__fzf_key_bindings_options
  'unset' '__fzf_key_bindings_options'
}
