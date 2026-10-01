[[ -o interactive ]] || return
source "$HOME/.config/shell/env.sh"
source "$HOME/.config/shell/interactive.sh"
typeset -U path PATH
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=20000
setopt APPEND_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE
bindkey -e
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
zstyle ':completion:*' menu select
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%# '
if [ -r "$HOME/.config/shell/zsh.local" ]; then
    . "$HOME/.config/shell/zsh.local"
fi
