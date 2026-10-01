# Windows / VS Code setup

These are merge snippets. Preserve unrelated application settings. Windows-side
configuration was inspected but not modified; the WSL Remote debounce overrides
were backed up and removed. No workspace settings are required.

## Extension host and settings

The recommended route uses the extension's default Windows UI host with a Neovim
backend in WSL. This follows [vscode-neovim's WSL support](https://github.com/vscode-neovim/vscode-neovim#readme).
The installed version 1.20.0 declares host preference `["ui", "workspace"]`.

1. In Windows VS Code, open Extensions, find `asvetliakov.vscode-neovim`, and ensure
   it is installed/enabled locally on Windows. A WSL-only installation is not
   sufficient for the UI-host route. Open a folder through Remote - WSL.
2. Run **Preferences: Open User Settings (JSON)** from the Command Palette. Merge
   [the User settings snippet](../vscode/settings.json). On this machine the Linux
   executable is `/home/futha/.local/bin/nvim`; on a fresh machine replace the username.
   Do not use `/usr/local/bin/nvim`: the existing AppImage there requires unavailable FUSE.
3. In those User settings, remove both entries below from `remote.extensionKind`:
   `"asvetliakov.vscode-neovim": ["workspace"]` and the placeholder `"pub.name": ["ui"]`.
   If that leaves an empty object, remove the setting. Default host selection can now
   use Windows; `useWSL: true` launches the backend in the default WSL distribution.
   In PowerShell, run `wsl --list --verbose` and make the intended Ubuntu distribution
   the default with `wsl --set-default <distribution>` if necessary.
4. Remove `extensions.experimental.affinity`'s Neovim entry for this baseline.
   It is still an experimental setting, not assumed deprecated; add it back only
   if profiling your actual extension host shows a benefit. No affinity is needed
   for correct operation.
5. Set `vscode-neovim.neovimClean` to `false`: the current `true` skips dotfiles.
   Remove custom `vscode-neovim.neovimInitVimPaths.*` values if present so Neovim
   loads `~/.config/nvim/init.lua`. Windows executable paths are unused on this WSL route.
6. Run **Preferences: Open Remote Settings (JSON)** while connected to WSL. Remove
   any overrides of the settings above and remove
   `vscode-neovim.mouseSelectionDebounceTime` and
   `vscode-neovim.normalSelectionDebounceTime`. The inspected values were 0 and 20;
   default behavior is the baseline. The WSL file was already cleaned locally.
7. Check `.vscode/settings.json` and any `.code-workspace` file for overrides of
   these same settings. Remove conflicts; do not put personal host paths in projects.
8. Run **Developer: Reload Window**. **Developer: Show Running Extensions** should
   show Neovim on the local host, while `:echo has('wsl')` in its command line should
   return 1 and `:echo g:vscode` should be set. `:set clipboard?` should show
   `unnamedplus`; `:echo g:clipboard.name` should show `VSCodeClipboard`.

If you prefer the already-installed WSL workspace host instead, deliberately retain
`remote.extensionKind: { "asvetliakov.vscode-neovim": ["workspace"] }` in User settings,
set `vscode-neovim.useWSL` to false, and merge
[remote-settings.json](../vscode/remote-settings.json) through **Open Remote Settings
(JSON)**. Install/enable the extension in WSL. Linux then launches Neovim directly.
Choose one route; avoid combining a forced remote host with Windows launch assumptions.

Relative line numbers are for the editor UI; smooth scrolling and animated carets
are disabled to keep one responsive rendering layer. Neovim animations and Snacks
scrolling are separately disabled in Lua. Do not tune debounce settings before testing defaults.

## User keybindings

Run **Preferences: Open Keyboard Shortcuts (JSON)**. This opens Windows User
`keybindings.json`, not WSL Remote settings or a project's settings file.

Delete the four inspected entries for Ctrl+D / Ctrl+U: the negative
`-vscode-neovim.ctrl-d` / `-vscode-neovim.ctrl-u` commands and the custom
`vscode-neovim.send` entries with `<C-d>` / `<C-u>` arguments. The extension's own
scroll commands already synchronize Neovim and the VS Code viewport. Use those defaults.
Merge [keybindings.json](../vscode/keybindings.json) for Ctrl+^ (US-layout Ctrl+Shift+6);
it is not in the extension's Ctrl-key setting enumeration. On another keyboard
layout, use Keyboard Shortcuts' key recorder to bind the same command to your desired key.

The two `ctrlKeys...` arrays in User settings are complete replacements, not additions.
Normal/Visual mode retains the important Vim Ctrl commands below. Insert mode keeps
native Vim register insertion, temporary Normal mode and small editing commands;
VS Code retains completion and standard clipboard/workbench UI.

## Keyboard ownership

These workbench keys are intended to use VS Code's normal Windows defaults. The
extension's installed keybinding manifest and existing User bindings were audited;
GUI dispatch could not be tested from this session. Verify with **Developer: Toggle
Keyboard Shortcuts Troubleshooting**, press a shortcut, and inspect the logged command.
Use **Preferences: Open Keyboard Shortcuts** to inspect conflicts and change only
conflicting User entries. Extensions or keyboard layouts may change exact defaults.

| Shortcut in editor | Owner | Result |
| --- | --- | --- |
| Ctrl+R | Neovim | Redo |
| Ctrl+D / U | vscode-neovim scroll commands | Half-page down / up with synchronized viewport |
| Ctrl+F / B | vscode-neovim scroll commands | Page down / up; native Vim navigation intent |
| Ctrl+E / Y | vscode-neovim scroll commands | Scroll one line down / up |
| Ctrl+O / I | Neovim / extension jump integration | Older / newer jump |
| Ctrl+W | Neovim / extension window integration | Vim window-command prefix; workbench groups |
| Ctrl+V | Neovim in Normal/Visual; VS Code in Insert | Block Visual mode / system paste |
| Ctrl+] | Neovim / extension navigation | Tag/definition jump, delegated to VS Code where supported |
| Ctrl+A / X | Neovim | Increment / decrement number |
| Ctrl+N | Neovim | Next line in Normal; VS Code suggestions in Insert |
| Ctrl+P | VS Code, approved change | Quick Open; Vim previous-line equivalent is `k` |
| Ctrl+T | VS Code, approved change | Workspace symbols; Vim tag-stack pop remains `:pop` |
| Ctrl+^ | Explicit vscode-neovim keybinding | Alternate buffer; extent depends on extension buffer model |
| Ctrl+H / J / K / L | Neovim in Normal | Native left / down / unused / redraw, without custom split interception |
| Ctrl+Shift+E | VS Code | Explorer |
| Ctrl+K, Ctrl+O | VS Code | Open Folder |
| Ctrl+Shift+F | VS Code | Workspace search |
| Ctrl+Shift+G | VS Code | Source Control (verify binding; `<leader>gg` also works) |
| Ctrl+Shift+D / X | VS Code | Debug / Extensions |
| Ctrl+Shift+P | VS Code | Command Palette |
| Ctrl+Shift+O | VS Code | File symbols |
| Ctrl+` | VS Code | Terminal |
| Ctrl+Shift+M | VS Code | Problems |
| j / k, Ctrl+[ / Escape | Neovim / extension | Literal movement, mode switching |

Ctrl+P and Ctrl+T change only in VS Code; standalone preserves native Vim commands.
Ctrl+H/J/K/L no longer invoke custom smart-splits under VS Code; use Ctrl+W h/j/k/l
or native VS Code group navigation. Standalone retains LazyVim's normal window mappings.
Ctrl+K workbench chords can conflict with native Vim Ctrl+K delivery; use the leader
mapping or Command Palette for Open Folder if needed, or customize the workbench chord.

Space is the leader. Official LazyVim VS Code mappings are retained without copying
its implementation; [the official extra](https://www.lazyvim.org/extras/vscode) filters
plugins according to editing needs. Our own mappings only fill gaps and fix j/k.

| Mapping | Glue action |
| --- | --- |
| Space Space, Space ff | Quick Open (first supplied by LazyVim) |
| Space /, Space sg | Workspace search (first supplied by LazyVim) |
| Space ss / sS | File / workspace symbols |
| Space e | Explorer |
| Space cr / ca | Rename / code action |
| Space xx | Problems |
| Space gg | Source Control |
| Space ft / fT | Terminal (LazyVim) |
| Space : | Command Palette |
| H / L | Previous / next editor (LazyVim) |
| Space bd | Close editor |

## Live acceptance check

After reloading, open a scratch file. Verify rapid j/k, counted movement, Escape,
Ctrl+D/U/F/B, undo then Ctrl+R redo, and `yy`, `dd`, `p`, `P` against the Windows
clipboard. Test Ctrl+P, Ctrl+Shift+P and the workbench shortcuts above from Normal
mode. Confirm there is no Neovim statusline, picker, completion UI or animation layer.
Standalone `nvim` should still provide its native LazyVim UI.
