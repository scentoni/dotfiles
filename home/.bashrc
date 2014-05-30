# ~/.bashrc is the place to put stuff that applies only to bash
# itself, such as alias and function definitions, shell options, and
# prompt settings. (You could also put key bindings there, but for
# bash they normally go into ~/.inputrc.)

# If not running interactively, don't do anything
[[ $- == *i* ]] || return

shopt -s no_empty_cmd_completion

export TERM=xterm-256color
reset="\[$(tput sgr0)\]"
bold="\[$(tput bold)\]"
yellow="\[$(tput setaf 3)\]"
  
export PS1="$yellow$bold\u@$IPNUMBERS\h:\w \$$reset "
# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
elif ls -G > /dev/null 2>&1; then # OS X `ls`
    colorflag="-G"
fi

alias ..='cd ..'
alias ls="ls ${colorflag}"
alias ll='ls -FlA'

function cats {
    for var in "$@"; do
        echo
        echo "${var}:"
        echo "\`\`\`"
        cat "${var}"
        echo
        echo "\`\`\`"
    done
}

function revsed { sed '/\n/!G;s/\(.\)\(.*\n\)/&\2\1/;//D;s/.//'; }

function pandoh { pandoc $1.md -o $1.html && open $1.html; }

function md { mkdir -p "$@" ; cd "$@"; }

function vipath () {
    echo $PATH | tr ':' '\n' >$HOME/.vipath;
    $EDITOR $HOME/.vipath;
    export PATH=`<$HOME/.vipath tr '\n' ':' | sed -e 's/:*$//'`
}

ssh() {
    if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
        tmux rename-window "$*"
        command ssh "$@"
        tmux set-window-option automatic-rename "on" 1>/dev/null
    else
        command ssh "$@"
    fi
}

# From Andy Buckley http://pastebin.com/xS9sgQsX
## Path manipulation functions

## Reprint a colon-separated path with each element on a separate line
function pathsplit {
    # TODO: add customisation of split character
    # TODO: clean first? Configurable?
    case $# in
        0) read i && pathhead "$i";;
        1) echo "$1" | sed $'s/:/\\\n/g';;
        *) echo "Usage: pathsplit <path> or echo <path> | pathsplit"; return 1;;
    esac
}


## Print the first element on a colon-separated path
function pathhead {
    case $# in
        0) read i && pathhead "$i";;
        1) echo "$1" | sed -e 's/\([^:]\+\):\?\(.*\)/\1/g';;
        *) echo "Usage: pathhead <path> or echo <path> | pathhead"; return 1;;
    esac
}


## Print the trailing elements (if any) on a colon-separated path
function pathtail {
    case $# in
        0) read i && pathtail "$i";;
        1) echo "$1" | sed -e 's/\([^:]\+\):\?\(.*\)/\2/g';;
        *) echo "Usage: pathtail <path> or echo <path> | pathtail"; return 1;;
    esac
}


## Remove accidental repeated and leading/trailing colon separators from a path
function pathclean {
    case $# in
        0) read i && pathclean "$i";;
        1) echo "$1" | sed -e 's/:\+/:/g' -e 's/^://g' -e 's/:$//g';;
        *) echo "Usage: pathclean <path> or echo <path> | pathclean"; return 1;;
    esac
}
## Same function as pathclean, but applied in-place to a named path
function pathcleani {
    case $# in
        1) tmp=$(eval "pathclean \$$1"); eval "$1=$tmp"; unset tmp;;
        *) echo "Usage: pathcleani <varname>"; return 1;;
    esac
}


## Reduce a colon-separated path so that each entry appears at most once (at its earliest position)
function pathuniq {
    case $# in
        0) read i && pathclean "$i";;
        1) tmp=`pathclean $1`
            rtn=""
            while true; do
                head=`pathhead "$tmp"`
                test -z "$head" && break # Escape if the string is empty
                tmp=`pathtail "$tmp"`
                #echo "$head ... $tmp => $rtn" # Debug printout
                (echo ":$rtn:" | grep ":$head:" &> /dev/null) && continue
                rtn="$rtn:$head"
            done
            pathclean $rtn
            ;;
        *) echo "Usage: pathuniq <path> or echo <path> | pathuniq"; return 1;;
    esac
}
## Same function as pathuniq, but applied in-place to a named path
function pathuniqi {
    case $# in
        1) tmp=$(eval "pathuniq \$$1"); eval "$1=$tmp"; unset tmp;;
        *) echo "Usage: pathuniqi <varname>"; return 1;;
    esac
}


## Prepend a new path to an existing named path variable
function pathprepend() {
    # TODO: optionally do uniqueness as well as cleaning
    # TODO: make cleaning optional
    case $# in
        2) eval "tmp=$2:\$$1"; pathclean "$tmp";;
        *) echo "Usage: pathprepend <varname> <path_to_add>"; return 1;;
    esac
}
## Same function as pathprepend, but applied in-place to the named path
function pathprependi() {
    case $# in
        2) tmp=`pathprepend $1 $2`; eval "$1=$tmp";;
        *) echo "Usage: pathprependi <varname> <path_to_add>"; return 1;;
    esac
}


## Append a new path to an existing named path variable
function pathappend() {
    # TODO: optionally do uniqueness as well as cleaning
    # TODO: make cleaning optional
    case $# in
        2) eval "tmp=\$$1:$2"; pathclean "$tmp";;
        *) echo "Usage: pathappend <varname> <path_to_add>"; return 1;;
    esac
 }
## Same function as pathprepend, but applied in-place to the named path
function pathappendi() {
    case $# in
        2) tmp=`pathappend $1 $2`; eval "$1=$tmp";;
        *) echo "Usage: pathappendi <varname> <path_to_add>"; return 1;;
    esac
}


## Remove a path element from a colon-separated path
function pathrm() {
    case $# in
        2) tmp=`echo ":$1:" | sed -e "s/:$2:/:/g"`; pathclean $tmp;;
        *) echo "Usage: pathrm <path> <path_to_rm>"; return 1;;
    esac
}
## Same function as pathrm, but applied in-place to the named path
function pathrmi() {
    case $# in
        2) tmp=$(eval "pathrm \$$1 $2"); eval "$1=$tmp";;
        *) echo "Usage: pathrmi <varname> <path_to_rm>"; return 1;;
    esac
}


## List the absolute path to a relatively-specified file/dir
function pathto() {
    case $# in
        0) pwd;;
        1) dir=$(cd `dirname $1` && pwd); pathclean "$dir/`basename $1`";;
        *) echo "Usage: pathto <relpath>"; return 1;;
    esac
}
