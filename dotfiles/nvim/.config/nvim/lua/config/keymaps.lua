-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste over without copy to register" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete without copy to register" })

vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank to clipboard" })

vim.keymap.set("n", "<leader>xf", "<cmd>!chmod +x %<CR>", { desc = "Make file executable" })
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Open tmux-sessionizer from vim" })

vim.keymap.set("v", "gy", "ygvgc", { remap = true, desc = "Yank and comment" })

-- Override LazyVim keymaps
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")

vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to down window" })
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to up window" })
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to right window" })

vim.keymap.set("n", "<leader>ac", function()
  local filter = { bufnr = 0 }
  local enabled = not vim.lsp.inline_completion.is_enabled(filter)

  vim.lsp.inline_completion.enable(enabled, filter)

  vim.notify(
    "Copilot inline completion " .. (enabled and "enabled" or "disabled"),
    enabled and vim.log.levels.INFO or vim.log.levels.WARN
  )
end, { desc = "Toggle Copilot Inline Completion" })
