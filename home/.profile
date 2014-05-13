# ~/.profile is the place to put stuff that applies to your whole
# session, such as programs that you want to start when you log in
# (but not graphical programs, they go into a different file), and
# environment variable definitions.


export PATH=\
/opt/csw/bin:\
/usr/local/sbin:\
/usr/local/bin:\
/usr/sfw/bin:\
/usr/gnu/bin:\
/usr/ccs/bin:\
/usr/xpg6/bin/
/sbin:\
/usr/sbin:\
/bin:\
/usr/bin:\
/usr/ucb:\
$HOME/bin:\
$HOME/go/bin:\
/usr/local/go/bin:\
$PATH

export MANPATH="/usr/share/man:/opt/csw/share/man:$HOME/share/man:$MANPATH"

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
