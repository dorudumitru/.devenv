return {
  "mfussenegger/nvim-jdtls",
  opts = function(_, opts)
    opts.settings = opts.settings or {}
    opts.settings.java = opts.settings.java or {}

    -- opts.settings.java.inlayHints = {
    --   parameterNames = { enabled = "none" },
    -- }

    opts.jdtls = function(config)
      if LazyVim.has("spring-boot.nvim") then
        config.init_options = config.init_options or {}
        config.init_options.bundles =
          vim.list_extend(vim.deepcopy(config.init_options.bundles or {}), require("spring_boot").java_extensions())
      end
      return config
    end

    return opts
  end,
}
