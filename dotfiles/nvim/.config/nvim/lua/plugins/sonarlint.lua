return {
  "https://gitlab.com/schrieveslaach/sonarlint.nvim.git",
  lazy = true,
  ft = { "typescript", "javascript", "go", "python" },
  config = function()
    require("sonarlint").setup({
      server = {
        cmd = {
          vim.fn.expand("$MASON/bin/sonarlint-language-server"),
          "-stdio",
          "-analyzers",
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonargo.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
        },
      },
      filetypes = {
        "typescript",
        "javascript",
        "go",
        "python",
      },
    })
  end,
}
