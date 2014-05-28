# ~/.profile is the place to put stuff that applies to your whole
# session, such as programs that you want to start when you log in
# (but not graphical programs, they go into a different file), and
# environment variable definitions.

export PATH=\
$HOME/bin:\
$HOME/go/bin:\
/opt/csw/gnu:\
/opt/csw/sbin:\
/opt/csw/bin:\
/usr/local/sbin:\
/usr/local/bin:\
/sbin:\
/bin:\
/usr/sbin:\
/usr/bin:\
/usr/sfw/bin:\
/usr/sfw/sbin:\
/opt/sfw/bin:\
/opt/sfw/sbin:\
/opt/SUNWspro/bin:\
/opt/SUNWjet/bin:\
/usr/ucb:\
/usr/ccs/bin:\
/usr/gnu/bin:\
/usr/xpg6/bin:\
/usr/local/go/bin:\
$PATH

export MANPATH=\
$HOME/share/man:\
/usr/share/man:\
/opt/csw/share/man:\
/opt/SUNWjet/man:\
/usr/sfw/share/man:\
/opt/SUNWexplo/man:\
/opt/SUNWspro/man:\
$MANPATH

export GOPATH=$HOME/go
export PAGER="/usr/bin/less -ins"
#export TERM=xterm
export PERL_BADLANG=0
export HISTCONTROL=ignoredups:ignorespace
export VISUAL=vim
export EDITOR=vim
export GREP_OPTIONS='--color=auto'
export LESS="-insMR"
export TERMINFO=$HOME/.terminfo

#export IPNUMBERS=`ifconfig -a|awk 'BEGIN{ORS="="} /inet/ && $2 !~ /127.0.0.1/ && $2 !~ /0.0.0.0/ {print $2}'|sed -e 's/=*$//'`
#export IPNUMBERS=`ifconfig -a|sed -e 's/ addr:/ /'|awk 'BEGIN{ORS="="} /inet / && $2 !~ /127.0.0.1/ && $2 !~ /0.0.0.0/ {print $2}'|sed -e 's/=*$//'`
export IPNUMBERS=`ifconfig -a|sed -e 's/ addr:/ /'|awk 'BEGIN{ORS="="} /inet / && $2 !~ /127.0.0.1/ && $2 !~ /0.0.0.0/ {print $2}'`

[ -f $HOME/.bashrc ] && . $HOME/.bashrc
