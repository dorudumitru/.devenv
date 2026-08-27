return {
  "catppuccin/nvim",
  lazy = true,
  name = "catppuccin",
  opts = {
    transparent_background = true,
    float = {
      transparent = true,
    },
    integrations = {
      rainbow_delimiters = true,
    },
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      loops = { "italic" },
      functions = {},
      keywords = { "italic" },
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    highlight_overrides = {
      all = function(macchiato)
        return {
          ["@lsp.type.variable.rust"] = { fg = macchiato.sky }, -- interpolated variables
          ["@lsp.type.formatSpecifier.rust"] = { fg = macchiato.peach }, -- interpolated variables curly braces
          ["@lsp.mod.format.go"] = { fg = macchiato.sky }, -- format placeholders in strings
        }
      end,
    },
  },
}
