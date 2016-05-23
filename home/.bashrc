# ~/.bashrc is the place to put stuff that applies only to bash
# itself, such as alias and function definitions, shell options, and
# prompt settings. (You could also put key bindings there, but for
# bash they normally go into ~/.inputrc.)

# If not running interactively, don't do anything
[[ $- == *i* ]] || return

# Don't bother trying to do cmd completion for an empty line
shopt -s no_empty_cmd_completion

# Disable core files
ulimit -S -c 0 > /dev/null 2>&1

if hash vim 2>/dev/null; then
  export EDITOR=vim
else
  export EDITOR=vi
fi

# export TERM=xterm-256color
export TERM=xterm
reset="\[$(tput sgr0)\]"
bold="\[$(tput bold)\]"
yellow="\[$(tput setaf 3)\]"
export PS1="$yellow$bold\u@$IPNUMBERS\h:\w \$$reset "

function timer_start {
  #echo -ne "\e[0m"
  timer=${timer:-$SECONDS}
}

function timer_stop {
  timer_show=$(($SECONDS - $timer))
  unset timer
}

trap 'timer_start' DEBUG
PROMPT_COMMAND=timer_stop

case "$OSTYPE" in
  solaris*) oschar="S" ;;
  darwin*)  oschar="M" ;; 
  linux*)   oschar="L" ;;
  hpux*)    oschar="H" ;;
  aix*)     oschar="I" ;;
  *bsd*)    oschar="B" ;;
  *)        oschar="?" ;;
esac

#PS1='[last: ${timer_show}s][\w]\$ '
#PS1='\[\e[34m\]$([ $timer_show -gt 10 ] && echo -e "\a[${timer_show}s]")[\h:\w]\$ \[\e[46m\]\[\e[30m\]'
#PS1='\[\e[34m\]\[\e[43m\]$([ $timer_show -gt 10 ] && echo -e "\a[${timer_show}s]")\h:\w\$ \[\e[43m\]\[\e[30m\]'
#PS1='\[\e[34m\]\[\e[43m\]$([ $timer_show -gt 10 ] && echo -e "\a[${timer_show}s]")\h:\w\$\[\e[40m\]\[\e[33m\]▶\[\e[0m\]'
#PS1='$oschar\[\e[34m\]\[\e[43m\]$([ $timer_show -gt 10 ] && echo -e "\a[${timer_show}s]")\h:\w\$\[\e[40m\]\[\e[33m\]▶\[\e[0m\]'
#PS1='\[\e[34m\]$oschar\[\e[43m\]$([ $timer_show -gt 10 ] && echo -e "\a[${timer_show}s]")\h:\w\$\[\e[40m\]\[\e[33m\]>\[\e[0m\]'
PS1='\[\e[34m\e[43m\]$(es=$?; [ $es -ne 0 ] && echo -e "\[\a\][exit code $es]\[\n\]")$([ $timer_show -gt 9 ] && echo -e "\[\a\][${timer_show}s]\[\n\]")\h:\w\$\[\e[40m\e[33m\e[0m\]$oschar>'

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
elif ls -G > /dev/null 2>&1; then # OS X `ls`
    colorflag="-G"
fi
alias ls="ls ${colorflag}"

alias ..='cd ..'
alias ...='cd ...'
alias ....='cd ....'
alias ll='ls -FlAthr'
alias h='history'
alias j='jobs -l'
alias ports='netstat -tulanp'
alias tre="find . -print | sed -e 's:[^/]*/:|____:g;s:____|: |:g'"

# http://tldp.org/LDP/abs/html/process-sub.html
# Process substitution can compare the contents of two directories -- to see which filenames are in one, but not the other.
#diff <(ls $first_directory) <(ls $second_directory)

# `treee` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
treee () {
  tree -aC -I '.git' --dirsfirst "$@" | less -FRNX
}

# Get colors in manual pages
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

# use p4merge to open files
# http://answers.perforce.com/articles/KB/2848
alias p4merge='/Applications/p4merge.app/Contents/MacOS/p4merge'


# use Pandoc to convert Markdown to HTML
p2h () {
  for f in "$@"; do
    pandoc --self-contained -c $HOME/.pandoc/pandoc.css $f -o ${f%.md}.html
  done
}

# remove desktop dregs files
cleanse () {
  find /share -type f -name 'Thumbs.db' -exec rm {} \;
  find /share -type f -name '*.DS_Store' -exec rm {} \;
  find /share -type f -name '.fuse*' -exec rm {} \;
  find /share -type f -name '.nfs*' -exec rm {} \;
}

# print filename followed by contents of file
# Usage: cats .*rc
cats () {
    for var in "$@"; do
        echo
        echo "${var}:"
        echo "\`\`\`"
        cat "${var}"
        echo
        echo "\`\`\`"
    done
}

# http://stackoverflow.com/questions/4210042/exclude-directory-from-find-command
sloc () {
    find "$@" -not \( -path */.svn -prune \) -not \( -path */.git -prune \) -type f |xargs wc -l
}

# colorize unified diff output
# Usage: diff -u a b | colorizediff
# Usage: svn diff | colorizediff
colorizediff () {
    case $(uname -s) in
        Darwin|FreeBSD)
            sed "s/^-/`echo -e \"\x1b\"`[41m-/;s/^+/`echo -e \"\x1b\"`[42m+/;s/^@/`echo -e \"\x1b\"`[34m@/;s/$/`echo -e \"\x1b\"`[0m/"
        ;;
        Linux|SunOS)
            sed 's/^-/\x1b[41m-/;s/^+/\x1b[42m+/;s/^@/\x1b[34m@/;s/$/\x1b[0m/'
        ;;
    esac
}

# inspired by http://stackoverflow.com/questions/981601/colorized-grep-viewing-the-entire-file-with-highlighted-matches
# cat ~/.bashrc |highlight red path |highlight 36m case
function highlight() {
    CSI=$(echo -e '\033[')
    case $1 in
        black)   seq="30m";;
        red)     seq="31m";;
        green)   seq="32m";;
        yellow)  seq="33m";;
        blue)    seq="34m";;
        magenta) seq="35m";;
        cyan)    seq="36m";;
        *)       seq="$1";;
    esac
    sed "s/$2/${CSI}${seq}&${CSI}0m/g"
}

# strip comments and blank lines
# Usage: nocomment <~/.bashrc
nocomment () {
    sed -e's/#.*//;/^[[:space:]]*$/d'
}

# Usage: psgrep cron
psgrep() {
    ps -ef | tee >(head -1>&2) | grep -v " grep $@" | grep "$@" -i --color=auto
}

# reverse the contents of each line
revsed () {
    sed '/\n/!G;s/\(.\)\(.*\n\)/&\2\1/;//D;s/.//'
}

# create directory if it doesn't exist then change to it
# md ~/etc
md () {
    mkdir -p "$@"
    cd "$@"
}

# remove non-consecutive duplicate lines (vs. uniq)
# Usage: echo $PATH | tr : \\n | unic
unic () {
    awk '!a[$0]++' "$@"
}

# get version for every executable in $PATH
# Usage: versionall python
versionall () {
  for p in $(type -ap "$@" |unic); do
    echo -n "$p: "
    $p --version
  done
}

# edit an environment variable, interpreting colons as newlines
# Usage: edv MANPATH
edv () {
    tmpfile=$(mktemp -t edv.XXXXXX)
    varname=$1
    echo ${!varname} | tr ':' '\n' >$tmpfile
    $EDITOR $tmpfile
    export $varname=`<$tmpfile tr '\n' ':' | sed -e 's/:*$//'`
}

# show all instances of the program in the path
# whichall cd ls
whichall () {
    type -ap "$@" |xargs ls -l
}

# renumber tmux windows
tmuxrenumber () {
    $i = $(tmux show-options -g|grep base|cut -d' ' -f2)
    tmux list-windows | cut -d: -f1 | while read winindex; do 
      if (( winindex != i )); then
        tmux move-window -d -s $winindex -t $i
      fi
      (( i++ ))
    done
}

# label tmux windows upon ssh
tsh () {
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
pathsplit () {
    # TODO: add customisation of split character
    # TODO: clean first? Configurable?
    case $# in
        0) read i && pathhead "$i";;
        1) echo "$1" | sed $'s/:/\\\n/g';;
        *) echo "Usage: pathsplit <path> or echo <path> | pathsplit"; return 1;;
    esac
}


## Print the first element on a colon-separated path
pathhead () {
    case $# in
        0) read i && pathhead "$i";;
        1) echo "$1" | sed -e 's/\([^:]\+\):\?\(.*\)/\1/g';;
        *) echo "Usage: pathhead <path> or echo <path> | pathhead"; return 1;;
    esac
}


## Print the trailing elements (if any) on a colon-separated path
pathtail () {
    case $# in
        0) read i && pathtail "$i";;
        1) echo "$1" | sed -e 's/\([^:]\+\):\?\(.*\)/\2/g';;
        *) echo "Usage: pathtail <path> or echo <path> | pathtail"; return 1;;
    esac
}


## Remove accidental repeated and leading/trailing colon separators from a path
pathclean () {
    case $# in
        0) read i && pathclean "$i";;
        1) echo "$1" | sed -e 's/:\+/:/g' -e 's/^://g' -e 's/:$//g';;
        *) echo "Usage: pathclean <path> or echo <path> | pathclean"; return 1;;
    esac
}
## Same function as pathclean, but applied in-place to a named path
pathcleani () {
    case $# in
        1) tmp=$(eval "pathclean \$$1"); eval "$1=$tmp"; unset tmp;;
        *) echo "Usage: pathcleani <varname>"; return 1;;
    esac
}


## Reduce a colon-separated path so that each entry appears at most once (at its earliest position)
pathuniq () {
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
pathuniqi () {
    case $# in
        1) tmp=$(eval "pathuniq \$$1"); eval "$1=$tmp"; unset tmp;;
        *) echo "Usage: pathuniqi <varname>"; return 1;;
    esac
}


## Prepend a new path to an existing named path variable
pathprepend () {
    # TODO: optionally do uniqueness as well as cleaning
    # TODO: make cleaning optional
    case $# in
        2) eval "tmp=$2:\$$1"; pathclean "$tmp";;
        *) echo "Usage: pathprepend <varname> <path_to_add>"; return 1;;
    esac
}
## Same function as pathprepend, but applied in-place to the named path
pathprependi () {
    case $# in
        2) tmp=`pathprepend $1 $2`; eval "$1=$tmp";;
        *) echo "Usage: pathprependi <varname> <path_to_add>"; return 1;;
    esac
}


## Append a new path to an existing named path variable
pathappend () {
    # TODO: optionally do uniqueness as well as cleaning
    # TODO: make cleaning optional
    case $# in
        2) eval "tmp=\$$1:$2"; pathclean "$tmp";;
        *) echo "Usage: pathappend <varname> <path_to_add>"; return 1;;
    esac
 }
## Same function as pathprepend, but applied in-place to the named path
pathappendi () {
    case $# in
        2) tmp=`pathappend $1 $2`; eval "$1=$tmp";;
        *) echo "Usage: pathappendi <varname> <path_to_add>"; return 1;;
    esac
}


## Remove a path element from a colon-separated path
pathrm () {
    case $# in
        2) tmp=`echo ":$1:" | sed -e "s/:$2:/:/g"`; pathclean $tmp;;
        *) echo "Usage: pathrm <path> <path_to_rm>"; return 1;;
    esac
}
## Same function as pathrm, but applied in-place to the named path
pathrmi () {
    case $# in
        2) tmp=$(eval "pathrm \$$1 $2"); eval "$1=$tmp";;
        *) echo "Usage: pathrmi <varname> <path_to_rm>"; return 1;;
    esac
}


## List the absolute path to a relatively-specified file/dir
pathto () {
    case $# in
        0) pwd;;
        1) dir=$(cd `dirname $1` && pwd); pathclean "$dir/`basename $1`";;
        *) echo "Usage: pathto <relpath>"; return 1;;
    esac
}

if type -ap brew >/dev/null && [ -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]; then
   # Set config variables first
   GIT_PROMPT_ONLY_IN_REPO=1

   # GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

   # GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch

   # GIT_PROMPT_STATUS_COMMAND=gitstatus_pre-1.7.10.sh # uncomment to support Git older than 1.7.10

   # GIT_PROMPT_START=...    # uncomment for custom prompt start sequence
   # GIT_PROMPT_END=...      # uncomment for custom prompt end sequence

   # as last entry source the gitprompt script
   # GIT_PROMPT_THEME=Custom # use custom .git-prompt-colors.sh
   # GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme
   GIT_PROMPT_THEME=Solarized

   source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
fi

source "$HOME/.homesick/repos/homeshick/homeshick.sh"

