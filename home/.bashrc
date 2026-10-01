case $- in *i*) ;; *) return ;; esac
. "$HOME/.config/shell/env.sh"
. "$HOME/.config/shell/interactive.sh"
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend checkwinsize
PS1='\u@\h:\w\$ '
if [ -r /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi
if [ -r "$HOME/.config/shell/bash.local" ]; then
    . "$HOME/.config/shell/bash.local"
fi
