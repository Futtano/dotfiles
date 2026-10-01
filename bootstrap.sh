#!/usr/bin/env bash
set -euo pipefail
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
case $(uname -m) in
    x86_64) nvim_arch=x86_64; ts_arch=x64 ;;
    aarch64) nvim_arch=arm64; ts_arch=arm64 ;;
    *) echo "Unsupported architecture" >&2; exit 1 ;;
esac
sudo apt-get update
sudo apt-get install -y git curl ca-certificates zsh tmux ripgrep fd-find fzf build-essential xclip unzip
nvim_version=v0.12.2
ts_version=v0.27.0
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
mkdir -p "$HOME/.local/bin" "$HOME/.local/opt"
nvim_dir="$HOME/.local/opt/nvim-$nvim_version"
if [[ ! -x "$nvim_dir/bin/nvim" ]]; then
    curl -fL "https://github.com/neovim/neovim/releases/download/$nvim_version/nvim-linux-$nvim_arch.tar.gz" -o "$tmp/nvim.tar.gz"
    mkdir "$tmp/nvim"
    tar -xzf "$tmp/nvim.tar.gz" --strip-components=1 -C "$tmp/nvim"
    mv "$tmp/nvim" "$nvim_dir"
fi
curl -fL "https://github.com/tree-sitter/tree-sitter/releases/download/$ts_version/tree-sitter-linux-$ts_arch.gz" -o "$tmp/tree-sitter.gz"
gzip -dc "$tmp/tree-sitter.gz" > "$tmp/tree-sitter"
chmod 755 "$tmp/tree-sitter"
# Preserve any executables being replaced, including symlinks.
backup="$HOME/.local/state/dotfiles/bin-backups/$(date +%Y%m%d-%H%M%S)-$$"
mkdir -p "$backup"
chmod 700 "$backup"
for name in nvim tree-sitter; do
    if [[ -e "$HOME/.local/bin/$name" || -L "$HOME/.local/bin/$name" ]]; then
        mv "$HOME/.local/bin/$name" "$backup/$name"
    fi
done
ln -s "$nvim_dir/bin/nvim" "$HOME/.local/bin/nvim"
mv "$tmp/tree-sitter" "$HOME/.local/bin/tree-sitter"
"$repo/install.sh"
printf 'Open a new shell, then run nvim to install plugins. Optional: chsh -s /usr/bin/zsh\n'
