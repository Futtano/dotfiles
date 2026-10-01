if not vim.g.vscode then
  return
end
local map = vim.keymap.set
local vscode = require("vscode")
for lhs, rhs in pairs({ j = "j", k = "k", ["<Down>"] = "j", ["<Up>"] = "k" }) do
  map({ "n", "x" }, lhs, rhs, { desc = rhs == "j" and "Down" or "Up" })
end
-- Preserve native Ctrl editing commands instead of LazyVim window shortcuts.
for _, key in ipairs({ "h", "j", "k", "l" }) do
  map("n", "<C-" .. key .. ">", "<C-" .. key .. ">", { desc = "Native Vim Ctrl+" .. key })
end
local actions = {
  ["<leader>e"] = { "workbench.view.explorer", "Explorer" },
  ["<leader>ff"] = { "workbench.action.quickOpen", "Find files" },
  ["<leader>sg"] = { "workbench.action.findInFiles", "Search workspace" },
  ["<leader>sS"] = { "workbench.action.showAllSymbols", "Workspace symbols" },
  ["<leader>cr"] = { "editor.action.rename", "Rename symbol" },
  ["<leader>ca"] = { "editor.action.quickFix", "Code action" },
  ["<leader>xx"] = { "workbench.actions.view.problems", "Problems" },
  ["<leader>gg"] = { "workbench.view.scm", "Source control" },
  ["<leader>:"] = { "workbench.action.showCommands", "Command Palette" },
  ["<leader>bd"] = { "workbench.action.closeActiveEditor", "Close editor" },
}
for lhs, action in pairs(actions) do
  map("n", lhs, function() vscode.action(action[1]) end, { desc = action[2] })
end
