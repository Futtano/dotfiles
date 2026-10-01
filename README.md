# WSL dotfiles

Small, symlink-based defaults for Ubuntu WSL: Zsh, Bash, Git, tmux, Kitty and
LazyVim. VS Code owns IDE features when it uses Neovim as its editing backend.

```sh
git clone https://github.com/Futtano/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh       # configuration only; backs up files it replaces
# Or, on a fresh Ubuntu WSL installation:
./bootstrap.sh     # apt dependencies + pinned Neovim/Tree-sitter + install
```

Open a new shell and run `nvim` to install plugins. Optional: `chsh -s /usr/bin/zsh`.
The installer does not modify Windows, SSH keys, credentials or the default shell.

- [Architecture, files and bootstrap](docs/setup.md)
- [Windows / VS Code setup and keyboard ownership](docs/vscode.md)
- [Cleanup decisions and validation](docs/review.md)

Keep private exports in `~/.config/shell/env.local` (mode 600), Git identity and
credential helpers in `~/.config/git/local`, and shell overrides in
`bash.local` / `zsh.local` beside `env.local`. These files are outside this repository.
Do not add the entire home directory to Git. Plugins, histories, caches and backups
are intentionally outside the tracked tree.
