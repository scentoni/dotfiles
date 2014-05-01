# ~/.profile is the place to put stuff that applies to your whole
# session, such as programs that you want to start when you log in
# (but not graphical programs, they go into a different file), and
# environment variable definitions.


export PATH=/sbin:\
/usr/sbin:\
/bin:\
/usr/bin:\
/usr/ucb:\
/usr/local/sbin:\
/usr/local/bin:\
/usr/sfw/bin:\
/usr/gnu/bin:\
/usr/ccs/bin:\
/opt/csw/bin:\
$HOME/bin:\
$HOME/go/bin:\
/usr/local/go/bin

export GOPATH=$HOME/go
export PAGER="/usr/bin/less -ins"
export TERM=xterm
export PERL_BADLANG=0

[ -f $HOME/.bashrc ] && . $HOME/.bashrc
