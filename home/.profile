[ -r "$HOME/.config/shell/env.sh" ] && . "$HOME/.config/shell/env.sh"
if [ -n "${BASH_VERSION:-}" ] && [ -r "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
