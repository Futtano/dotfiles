vim.g.snacks_animate = false
vim.opt.clipboard = "unnamedplus"
if not vim.g.vscode then
  -- WSLg supplies the Windows clipboard through Wayland/X11 providers.
  -- Without WSLg, OSC 52 works with terminals that support clipboard reads.
  if vim.env.WSL_DISTRO_NAME and not vim.env.WAYLAND_DISPLAY and not vim.env.DISPLAY then
    vim.g.clipboard = "osc52"
  end
end
