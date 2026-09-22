return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style           = "night",
      transparent     = true,
      terminal_colors = true,
      styles = {
        comments  = { italic = true },
        keywords  = { italic = true },
        functions = {},
        variables = {},
        sidebars  = "transparent",
        floats    = "transparent",
      },
      on_highlights = function(hl, c)
        hl.FloatBorder  = { fg = c.blue0, bg = "NONE" }
        hl.WinSeparator = { fg = c.blue0 }
        hl.CursorLine   = { bg = "#1a1c2c" }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight-night" },
  },
}
