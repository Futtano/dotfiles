# POSIX: shared by login shells and interactive Bash/Zsh.
for dotfiles_dir in /home/linuxbrew/.linuxbrew/sbin /home/linuxbrew/.linuxbrew/bin "$HOME/.opencode/bin" "$HOME/.pixi/bin" "$HOME/.cargo/bin" "$HOME/bin" "$HOME/.local/bin"; do
    [ -d "$dotfiles_dir" ] || continue
    case ":$PATH:" in *":$dotfiles_dir:"*) ;; *) PATH="$dotfiles_dir:$PATH" ;; esac
done
unset dotfiles_dir
export PATH
if command -v nvim >/dev/null 2>&1; then
    export EDITOR=nvim VISUAL=nvim
else
    export EDITOR=vi VISUAL=vi
fi
if [ -r "$HOME/.config/shell/env.local" ]; then
    . "$HOME/.config/shell/env.local"
fi
