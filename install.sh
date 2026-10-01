#!/usr/bin/env bash
set -euo pipefail
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
backup="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups/$(date +%Y%m%d-%H%M%S)-$$"
mkdir -p "$backup"
chmod 700 "$backup"
link() {
    local src=$1 dst=$2 rel=${2#"$HOME"/}
    if [[ -L "$dst" && $(readlink "$dst") == "$src" ]]; then return; fi
    if [[ -e "$dst" || -L "$dst" ]]; then
        mkdir -p "$backup/$(dirname "$rel")"
        mv -- "$dst" "$backup/$rel"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s -- "$src" "$dst"
}
while IFS= read -r -d '' src; do
    link "$src" "$HOME/${src#"$repo/home/"}"
done < <(find "$repo/home" -type f ! -path '*/nvim/*' -print0)
# Replace the Neovim directory as a unit so obsolete specs cannot survive.
link "$repo/home/.config/nvim" "$HOME/.config/nvim"
printf 'Installed dotfiles. Replaced files are in %s\n' "$backup"
