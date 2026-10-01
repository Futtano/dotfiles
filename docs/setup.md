# Architecture and installation

`home/` mirrors the home directory. `install.sh` links individual files, except
Neovim, whose directory is linked as a unit so old plugin specs cannot survive.
There is no dotfile manager, package framework or automatic plugin update check.

| File | Responsibility |
| --- | --- |
| `.profile` | POSIX login environment; start interactive Bash configuration when appropriate |
| `.zprofile` | Zsh login environment |
| `.bashrc`, `.zshrc` | Interactive history, completion, prompt and shell-specific overrides |
| `.config/shell/env.sh` | Shared idempotent PATH additions, editor selection, private exports |
| `.config/shell/interactive.sh` | Two listing aliases and lazy NVM initialization |
| `.gitconfig` | Main branch, fast-forward-only pull, prune fetch, histogram diff, local include |
| `.config/git/ignore` | Editor leftovers and known local agent settings |
| `.tmux.conf` | Default Ctrl+B prefix, vi copy mode, mouse, clipboard and directory-aware splits |
| `.config/kitty/kitty.conf` | Portable monospace font and silent bell |
| `.config/nvim/lua/config/lazy.lua` | LazyVim core, official VS Code extra and mini.surround |
| `.config/nvim/lua/config/options.lua` | Clipboard and animation policy |
| `.config/nvim/lua/config/keymaps.lua` | VS Code editing fixes and a small workbench vocabulary |
| `.config/nvim/lua/plugins/baseline.lua` | Explicit animation and duplicate UI exclusions |
| `.config/nvim/lazy-lock.json` | Reproducible plugin commits; update deliberately with `:Lazy update` |
| `vscode/` | JSON snippets to merge manually, not symlink or wholesale replacement files |

## Existing installation

Run `./install.sh` after moving the repository. Existing files are moved to
`~/.local/state/dotfiles/backups/<timestamp>-<pid>/` with a private backup directory.
Repeat runs leave correct symlinks intact. A new empty backup directory is harmless.
To roll back, remove the installed symlinks and move the corresponding backed-up
files to their original paths. Do not restore a Neovim backup into the linked directory.

Git identity is deliberately local:

```sh
mkdir -p ~/.config/git
git config --file ~/.config/git/local user.name 'Your Name'
git config --file ~/.config/git/local user.email 'you@example.com'
chmod 600 ~/.config/git/local
```

Authenticate using your preferred local credential manager or `gh auth login`;
never put access tokens in repository URLs. Existing identity and credential-helper
configuration were retained locally on the inspected machine. The old Windows Git
include and forced SSL backend were removed: Linux uses its native defaults.
`git pull` rejects divergent branches; choose merge or rebase explicitly per repository.

## Fresh Ubuntu WSL

1. Install Ubuntu WSL and Git (`sudo apt-get update && sudo apt-get install -y git`).
2. Clone the repository into `~/dotfiles` and run `./bootstrap.sh`.
3. The bootstrap installs apt dependencies and official Neovim v0.12.2 / Tree-sitter
   v0.27.0 binaries into `~/.local`, supporting x86_64 and arm64. It preserves replaced
   local binaries, uses a tarball rather than FUSE, and does not install language runtimes.
4. Open a new shell. Run `nvim`, wait for plugin installation, then use `:Lazy restore`
   and `:checkhealth lazy lazyvim`. C compiler, curl, tar and Tree-sitter are required
   for parsers. Install `lazygit` separately if you want its native Git UI; it is optional.
5. Configure local Git identity/authentication and optionally choose Zsh with
   `chsh -s /usr/bin/zsh`. Install a Nerd Font in your terminal if you want LazyVim icons.
6. Follow [VS Code setup](vscode.md). The bootstrap does not configure the Windows UI.

NVM remains optional: if `~/.nvm/nvm.sh` exists, Node/npm/npx/corepack load it on first
use. There is no duplicate initialization or runtime-version selection in dotfiles.
Use `uv run python` explicitly in projects; `python` is no longer a shell alias.
Conda, Pixi, uv, Homebrew and other installed runtimes were not uninstalled. Pixi,
Cargo, OpenCode, local executables and existing Linuxbrew directories enter PATH
only when present. No Windows PATH injection is added.

## Private configuration and SSH

Create `~/.config/shell/env.local` with `chmod 600` for private exports; only you
should edit or back it up. Never symlink it into the repository. The inspected
machine's existing application exports were moved there without changing values.
Bash/Zsh local overrides are sourced only in interactive shells.

No `~/.ssh` directory was present during inspection. Future keys and host details
remain local. If needed, use `Include ~/.ssh/config.d/*.conf` in a local SSH config;
no host, private key, agent or authentication policy is imposed by this baseline.

Existing `/etc/wsl.conf` already enables systemd and disables Windows PATH injection.
It was retained without modification. System files, application accounts, browser
profiles, histories and language environments are outside the managed dotfile scope.

## Clipboard

`unnamedplus` connects ordinary yanks/deletes/pastes to the system clipboard.
Explicit named registers and the black-hole register still work; deletes can overwrite
clipboard contents, which is standard Vim behavior with this option.
In VS Code, vscode-neovim supplies its clipboard provider; there are no PowerShell
or clip.exe subprocesses. Standalone uses WSLg's X11/Wayland provider (xclip is
installed). Without WSLg, the configuration selects Neovim's OSC 52 provider;
clipboard reads then depend on terminal support and its permissions. Check
`:checkhealth vim.provider` and test `yy`, `dd`, `p`, `P` in your actual terminal.
Tmux uses terminal clipboard escape sequences; its success also depends on the terminal.

## Repository tree

```text
dotfiles/
├── .gitignore
├── README.md
├── bootstrap.sh
├── docs/
│   ├── review.md
│   ├── setup.md
│   └── vscode.md
├── home/
│   ├── .bashrc
│   ├── .config/
│   │   ├── git/
│   │   │   └── ignore
│   │   ├── kitty/
│   │   │   └── kitty.conf
│   │   ├── nvim/
│   │   │   ├── init.lua
│   │   │   ├── lazy-lock.json
│   │   │   └── lua/
│   │   │       ├── config/
│   │   │       │   ├── keymaps.lua
│   │   │       │   ├── lazy.lua
│   │   │       │   └── options.lua
│   │   │       └── plugins/
│   │   │           └── baseline.lua
│   │   └── shell/
│   │       ├── env.sh
│   │       └── interactive.sh
│   ├── .gitconfig
│   ├── .profile
│   ├── .tmux.conf
│   ├── .zprofile
│   └── .zshrc
├── install.sh
└── vscode/
    ├── keybindings.json
    ├── remote-settings.json
    └── settings.json
```
