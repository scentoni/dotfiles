# ~/.bashrc is the place to put stuff that applies only to bash
# itself, such as alias and function definitions, shell options, and
# prompt settings. (You could also put key bindings there, but for
# bash they normally go into ~/.inputrc.)

# If not running interactively, don't do anything
[[ $- == *i* ]] || return

shopt -s no_empty_cmd_completion

reset="\[$(tput sgr0)\]"
bold="\[$(tput bold)\]"
yellow="\[$(tput setaf 3)\]"
  
export PS1="$yellow$bold\u@\h:\w \$$reset "

alias ..='cd ..'
alias ll='ls -FlAv'
pandoh(){ pandoc $1.md -o $1.html && open $1.html; }
