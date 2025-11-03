return {
  "mbbill/undotree",
  config = function()
    vim.keymap.set("n", "<leader>lh", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree ([L]ocal [H]istory)" })
  end,
}
