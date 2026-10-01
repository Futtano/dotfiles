# Cleanup review — 2026-10-01

## Removed from active configuration

- Oh My Zsh, its Git alias collection, autosuggestions and syntax highlighting:
  replaced with built-in completion and a simple prompt. Downloaded installations
  remain on disk, but no longer participate in startup.
- Oh My Posh initialization and two competing prompt themes: replaced with native
  prompts that do not execute Git or runtime probes.
- Repeated NVM sourcing and runtime-generated uv/uvx completion: NVM now loads once
  on first use; completion startup no longer invokes external generators.
- A second `compinit`: only Zsh's built-in initialization remains, using a cache
  under `~/.cache/zsh`.
- `python='uv run python'`, forced Python 3.13 selection and managed-runtime exports:
  removed to keep ordinary interpreter commands and project choices predictable.
- The WSL notification alias and custom WezTerm cwd hook: unnecessary for the
  shared baseline; terminal-specific customization can return in a local override.
- Bash's eager Homebrew subprocess: existing Linuxbrew executable directories
  enter PATH without running `brew shellenv` on every shell startup.
- TPM, resurrect/continuum and smart-splits tmux glue: replaced with built-in tmux
  features. No global Ctrl+H/J/K/L interception or broken `bc` version comparison.
  Plugin files and saved sessions remain local and recoverable.
- Multiple Neovim themes, mini.files versus Snacks Explorer, custom buffer navigation,
  text-case, aggregate mini.nvim, smart-splits and a large set of optional extras:
  replaced by LazyVim core and one editing extra, mini.surround.
- mini.animate and smear-cursor: explicitly disabled; Snacks animations and scrolling
  are disabled in both contexts. VS Code also excludes native IDE/UI plugins.
- Git's hardcoded Windows include, duplicate `user.mail`, SSL backend override and
  public identity: baseline is portable; existing identity/helper remain in a private include.
- Kitty's large generated/commented template and machine-specific font requirement:
  replaced with three portable settings.
- WSL Remote selection debounce overrides: backed up and reset to extension defaults.

Old active configuration files were backed up rather than erasing user data. Runtime
installations, accounts, histories, browser profiles, plugin downloads, completion
caches, AI tool credentials and unrelated application state were not deleted or tracked.
The obsolete shared shell files and prompt JSON files were moved into the private backup.

## Added

- Direct symlink installer with private backups and idempotent repeated runs.
- Fresh-WSL bootstrap for basic dependencies and pinned official binary releases.
- Local environment and Git include boundaries; existing private application exports
  are mode 600 and never enter the repository.
- Working local Neovim executable extracted from the installed AppImage to avoid FUSE.
- Tree-sitter CLI 0.27.0, required by the installed parser plugin.
- Official LazyVim VS Code integration, literal j/k, minimal workbench leaders and
  explicit duplicate Snacks feature exclusions.
- A small clipboard policy, portable tmux/Kitty defaults and manual VS Code snippets.

## Neovim plugins

Standalone retains LazyVim's core editing, parsing, LSP/completion, formatting,
search, status UI and diagnostics. The only explicitly selected editing extra is
mini.surround. Core mini.ai, mini.pairs and ts-comments remain. The official VS Code
extra conditionally filters core plugins; it does not install a second IDE there.
The baseline uses Tokyonight; Catppuccin remains a core LazyVim theme dependency,
without adding custom theme specs. Plugin downloads stay under `~/.local/share/nvim`.

Removed from the lockfile:

`SchemaStore.nvim`, `aerial.nvim`, `dial.nvim`, `inc-rename.nvim`, `koda.nvim`, `markdown-preview.nvim`, `mini.files`, `mini.hipatterns`, `mini.nvim`, `neotest`, `neotest-python`, `nvim-nio`, `nvim-treesitter-context`, `pastel.nvim`, `render-markdown.nvim`, `sidekick.nvim`, `smart-splits.nvim`, `teide.nvim`, `text-case.nvim`, `venv-selector.nvim`, `yanky.nvim`.

Retained in the standalone lockfile (including transitive dependencies):

`LazyVim`, `blink.cmp`, `bufferline.nvim`, `catppuccin`, `conform.nvim`, `flash.nvim`, `friendly-snippets`, `gitsigns.nvim`, `grug-far.nvim`, `lazy.nvim`, `lazydev.nvim`, `lualine.nvim`, `mason-lspconfig.nvim`, `mason.nvim`, `mini.ai`, `mini.animate`, `mini.icons`, `mini.pairs`, `mini.surround`, `noice.nvim`, `nui.nvim`, `nvim-lint`, `nvim-lspconfig`, `nvim-treesitter`, `nvim-treesitter-textobjects`, `nvim-ts-autotag`, `persistence.nvim`, `plenary.nvim`, `snacks.nvim`, `todo-comments.nvim`, `tokyonight.nvim`, `trouble.nvim`, `ts-comments.nvim`, `which-key.nvim`.

## Validation

- Bash, Zsh and installer/bootstrap syntax checked; Lua files compiled with Neovim.
- Zsh warm startup approximately 60 ms versus approximately 3 seconds before;
  Bash approximately 10 ms. These are measurements on this environment, not benchmarks.
- PATH checked for duplicate entries; idempotent sourcing and first-use Node/NVM verified.
- Standalone Neovim 0.12.2 loads without configuration errors; initial headless
  screen startup measured approximately 38 ms before VeryLazy plugins.
- `:Lazy restore` succeeded using existing installed commits; lockfile pruned to
  the selected standalone core and editing extra. No plugin downloads committed.
- `:checkhealth lazy lazyvim` passes after installing Tree-sitter and disabling unused
  LuaRocks support. Optional Python/Node/Ruby/Perl remote plugin providers are absent;
  the selected Lua plugins do not require them, so no extra host packages were added.
- VS Code branch exercised with `vim.g.vscode=true` and a stub for the VS Code API:
  literal j/k, clipboard option, animation exclusions, and conditional exclusion of
  LSP, completion, statusline, tabline, Mason and Trouble verified.
- Isolated tmux server starts with the new configuration and correct terminal type.
- Installer run twice to check existing links stay intact.
- Windows User settings and keybindings inspected read-only, plus the installed
  vscode-neovim 1.20.0 manifest and clipboard implementation. Actual VS Code GUI
  shortcut dispatch, remote-host migration and clipboard round trips require the
  manual acceptance check in `vscode.md`.
- Repository contents reviewed for secrets, private files, generated state and large
  artifacts before commit/push. Only hand-written configuration/docs and plugin commit
  metadata are tracked. Private export values were compared against repository files
  without printing them.

## Later decisions

Choose project language extras when needed by adding explicit imports to `lazy.lua`,
then update the lockfile deliberately. LazyVim UI selections/news (`lazyvim.json`)
are ignored generated state; avoid relying on local UI selections for shared configuration.
Decide whether shell autosuggestions provide enough value to restore independently.
Revisit terminal font, WSLg/OSC 52 clipboard support and tmux persistence after using
this baseline. Review VS Code extension-host placement only after measuring real latency.
Keep existing runtimes until project needs justify consolidating them; this cleanup
changes startup configuration rather than uninstalling project dependencies.
