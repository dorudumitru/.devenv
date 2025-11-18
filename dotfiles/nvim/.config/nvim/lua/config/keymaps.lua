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

-- VS Code
if vim.g.vscode then
  vim.keymap.set("n", "<leader>e", "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR>")
  vim.keymap.set("n", "]d", "<Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>")
  vim.keymap.set("n", "H", "<cmd>call VSCodeNotify('workbench.action.previousEditor')<cr>")
  vim.keymap.set("n", "L", "<cmd>call VSCodeNotify('workbench.action.nextEditor')<cr>")
  vim.keymap.set({ "n", "x" }, "<leader>ca", "<cmd>call VSCodeNotify('editor.action.quickFix')<cr>")
  vim.keymap.set({ "n", "x" }, "<leader>cr", "<cmd>call VSCodeNotify('editor.action.rename')<cr>")
  vim.keymap.set("n", "<leader>cf", "<cmd>call VSCodeNotify('editor.action.formatDocument')<cr>")
  vim.keymap.set("n", "<leader>co", "<cmd>call VSCodeNotify('editor.action.organizeImports')<cr>")
  vim.keymap.set("n", "<leader>ru", "<cmd>call VSCodeNotify('java.debug.runJavaFile')<cr>")
  vim.keymap.set("n", "<leader>st", "<cmd>call VSCodeNotify('workbench.action.debug.stop')<cr>")
  vim.keymap.set("n", "<leader>rr", "<cmd>call VSCodeNotify('workbench.action.debug.restart')<cr>")
  vim.keymap.set("n", "<C-D>", "mciw*<Cmd>nohl<CR>", { remap = true })
end

-- Override LazyVim keymaps
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")

vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to down window" })
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to up window" })
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to right window" })
