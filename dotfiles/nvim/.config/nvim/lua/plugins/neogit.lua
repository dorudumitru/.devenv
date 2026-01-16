return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "folke/snacks.nvim", -- optional
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gn", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
  },
}
