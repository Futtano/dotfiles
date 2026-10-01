return {
  { "nvim-mini/mini.animate", enabled = false },
  { "sphamba/smear-cursor.nvim", enabled = false },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.scroll = { enabled = false }
      if vim.g.vscode then
        for _, feature in ipairs({ "explorer", "terminal", "scope", "words" }) do
          opts[feature] = { enabled = false }
        end
      end
    end,
  },
}
