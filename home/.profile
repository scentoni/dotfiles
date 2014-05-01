# ~/.profile is the place to put stuff that applies to your whole
# session, such as programs that you want to start when you log in
# (but not graphical programs, they go into a different file), and
# environment variable definitions.

function mkcd {
  dir="$*";
  mkdir -p "$dir" && cd "$dir";
}

function appenv {
  if [ -z "${!1}" ]; then
      export "$1"="$2"
  else
      # if [ -d "$2" ] && [[ ! $1 =~ (^|:)$2(:|$) ]]; then
      if [ -d "$2" ] && [[ ":$1:" != *":$2:"* ]]; then
          export "$1"="${!1}:$2"
      fi
  fi
}

function prepenv {
  if [ -z "${!1}" ]; then
      export "$1"="$2"
  else
      if [ -d "$2" ] && [[ ":$1:" != *":$2:"* ]]; then
          export "$1"="$2:${!1}"
      fi
  fi
}

export PATH
appenv PATH /usr/bin
appenv PATH /usr/sbin
appenv PATH /sbin
prepenv PATH /usr/gnu/bin
prepenv PATH /usr/local/sbin
prepenv PATH /usr/local/bin
prepenv PATH /usr/sfw/bin
prepenv PATH /usr/ccs/bin
prepenv PATH /usr/ucb
prepenv PATH /opt/csw/bin
prepenv PATH $HOME/bin

export GOPATH=$HOME/go
appenv PATH $GOPATH/bin

export PAGER="/usr/bin/less -ins"
export TERM=xterm
export PERL_BADLANG=0

[ -f $HOME/.bashrc ] && . $HOME/.bashrc
