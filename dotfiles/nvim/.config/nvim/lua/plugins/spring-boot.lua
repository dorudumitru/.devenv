return {
  "JavaHello/spring-boot.nvim",
  ft = { "java", "jproperties" },
  dependencies = {
    "mfussenegger/nvim-jdtls",
  },
  opts = {
    server = {
      on_attach = function(client, bufnr)
        if vim.bo[bufnr].filetype == "java" then
          -- client.server_capabilities.renameProvider = false
          -- client.server_capabilities.codeActionProvider = false
          -- client.server_capabilities.definitionProvider = false
          client.server_capabilities.referencesProvider = false
          -- client.server_capabilities.implementationProvider = false
        end
      end,
      handlers = {
        ["textDocument/inlayHint"] = function(_, _, _, _, _)
          -- ...
        end,
      },
    },
  },
}
