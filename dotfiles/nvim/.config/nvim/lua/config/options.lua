-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.inccommand = "split"
vim.opt.scrolloff = 8
vim.opt.clipboard = ""
vim.opt.conceallevel = 2
vim.opt.concealcursor = ""

vim.filetype.add({
  -- Detect and assign filetype based on the extension of the filename
  extension = {
    pcss = "css",
    postcss = "css",
  },
  -- Detect and apply filetypes based on the entire filename
  filename = {
    [".env"] = "sh",
  },
  -- Detect and apply filetypes based on certain patterns of the filenames
  pattern = {
    -- Match filenames like - ".env.example", ".env.local" and so on
    [".env.*"] = "sh",
  },
})
