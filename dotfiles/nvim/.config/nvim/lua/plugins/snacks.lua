return {
  "folke/snacks.nvim",
  opts = {
    lazygit = {
      configure = false,
    },
    picker = {
      sources = {
        explorer = {
          auto_close = true,
          hidden = true,
          ignored = true,
          exclude = { ".git" },
        },
        projects = {
          format = "file",
          confirm = "load_session",
          recent = false,
          max_depth = 3,
          dev = {
            "~/Projects/personal",
            "~/Projects/work",
          },
          patterns = {
            ".git",
            ".project",
            "Makefile",
            "pom.xml",
            "gradle.build",
            "Cargo.toml",
            "go.mod",
          },
        },
      },
    },
  },
}
