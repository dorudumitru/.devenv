-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local bufname = vim.api.nvim_buf_get_name(event.buf)
    if bufname:find("^fugitive://") or bufname:find("^diffview://") then
      vim.schedule(function()
        vim.lsp.buf_detach_client(event.buf, event.data.client_id)
      end)
      return
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if client and client.name == "copilot" then
      vim.lsp.inline_completion.enable(false, {
        bufnr = ev.buf,
      })
    end
  end,
})
