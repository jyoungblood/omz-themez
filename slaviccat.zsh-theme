# OMZ version of OMF Slavic Cat: https://github.com/yangwao/omf-theme-slavic-cat/tree/master

# Color definitions
slavic_color_orange="%F{#FD971F}"
slavic_color_blue="%F{#6EC9DD}"
slavic_color_green="%F{#A6E22E}"
slavic_color_yellow="%F{#E6DB7E}"
slavic_color_pink="%F{#F92672}"
slavic_color_grey="%F{#554F48}"
slavic_color_white="%F{#F1F1F1}"
slavic_color_purple="%F{#e0aefa}"
slavic_color_lilac="%F{#AE81FF}"
reset_color="%f"

# Helper functions
slavic_git_status_codes() {
  git status --porcelain 2>/dev/null | sed -E 's/(^.{3}).*/\1/' | tr -d ' \n'
}

slavic_git_branch_name() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

slavic_rainbow() {
  if echo $1 | grep -q -e $3; then
    echo -n "${2}彡ミ"
  fi
}

slavic_git_status_icons() {
  local git_status=$(slavic_git_status_codes)
  
  slavic_rainbow "$git_status" "$slavic_color_pink" 'D'
  slavic_rainbow "$git_status" "$slavic_color_orange" 'R'
  slavic_rainbow "$git_status" "$slavic_color_white" 'C'
  slavic_rainbow "$git_status" "$slavic_color_green" 'A'
  slavic_rainbow "$git_status" "$slavic_color_blue" 'U'
  slavic_rainbow "$git_status" "$slavic_color_lilac" 'M'
  slavic_rainbow "$git_status" "$slavic_color_grey" '?'
}

slavic_git_status() {
  local branch_name=$(slavic_git_branch_name)
  if [[ -n $branch_name ]]; then
    echo -n "${slavic_color_blue} ☭ ${slavic_color_white}${branch_name}"
    
    if [[ -n $(slavic_git_status_codes) ]]; then
      echo -n "${slavic_color_pink} ●${slavic_color_white} (^._.^)ﾉ"
      slavic_git_status_icons
    else
      echo -n "${slavic_color_green} ○"
    fi
  fi
}

# Vi mode indicator
vim_ins_mode="${slavic_color_lilac}[${slavic_color_green}i${slavic_color_lilac}]${reset_color}"
vim_cmd_mode="${slavic_color_lilac}[${slavic_color_red}n${slavic_color_lilac}]${reset_color}"
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}

zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}

zle -N zle-line-finish

# Fix a bug when you C-c in CMD mode and you'd be prompted with CMD mode indicator, while in fact you would be in INS mode
# Fixed by catching SIGINT (C-c), set vim_mode to INS and then repropagate the SIGINT, so if anything else depends on it, we will not break it
function TRAPINT() {
  vim_mode=$vim_ins_mode
  return $(( 128 + $1 ))
}

# Prompt components
function precmd() {
  PROMPT='${vim_mode} ${slavic_color_purple}%~$(slavic_git_status)
${slavic_color_pink}⫸  ${reset_color}'
}

# Enable prompt substitution
setopt prompt_subst
