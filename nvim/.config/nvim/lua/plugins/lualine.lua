local mocha = {
  surface0 = "#313244",
  surface1 = "#45475a",
  mantle   = "#181825",
  base     = "#1e1e2e",
  text     = "#cdd6f4",
  subtext1 = "#bac2de",
  peach    = "#fab387",
  green    = "#a6e3a1",
  teal     = "#94e2d5",
  blue     = "#89b4fa",
  purple   = "#cba6f7",
  red      = "#f38ba8",
  yellow   = "#f9e2af",
}

local custom_theme = {
  normal = {
    a = { bg = mocha.purple,   fg = mocha.base, gui = "bold" },
    b = { bg = mocha.surface0, fg = mocha.text },
    c = { bg = "NONE",         fg = mocha.subtext1 },
  },
  insert = {
    a = { bg = mocha.green,    fg = mocha.base, gui = "bold" },
    b = { bg = mocha.surface0, fg = mocha.text },
    c = { bg = "NONE",         fg = mocha.subtext1 },
  },
  visual = {
    a = { bg = mocha.teal,     fg = mocha.base, gui = "bold" },
    b = { bg = mocha.surface0, fg = mocha.text },
    c = { bg = "NONE",         fg = mocha.subtext1 },
  },
  replace = {
    a = { bg = mocha.red,      fg = mocha.base, gui = "bold" },
    b = { bg = mocha.surface0, fg = mocha.text },
    c = { bg = "NONE",         fg = mocha.subtext1 },
  },
  command = {
    a = { bg = mocha.yellow,   fg = mocha.base, gui = "bold" },
    b = { bg = mocha.surface0, fg = mocha.text },
    c = { bg = "NONE",         fg = mocha.subtext1 },
  },
  inactive = {
    a = { bg = mocha.surface1, fg = mocha.subtext1 },
    b = { bg = mocha.surface0, fg = mocha.subtext1 },
    c = { bg = "NONE",         fg = mocha.subtext1 },
  },
}

return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      theme                = custom_theme,
      component_separators = "",
      section_separators   = { left = "", right = "" },
      globalstatus         = true,
      disabled_filetypes    = { statusline = { "dashboard", "alpha" } },
    },
    sections = {
      lualine_a = {
        {
          "mode",
          fmt = function(str) return " " .. str end,
          separator = { left = "", right = "" },
        },
      },
      lualine_b = {
        {
          "branch",
          icon = "",
          separator = { right = "" },
        },
      },
      lualine_c = {
        {
          "filename",
          path = 1,
          symbols = { modified = " ●", readonly = " ", unnamed = "…" },
          color  = { bg = mocha.peach, fg = mocha.base, gui = "bold" },
          separator = { left = "", right = "" },
          padding = { left = 1, right = 1 },
        },
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          diff_color = {
            added    = { bg = mocha.green,  fg = mocha.base },
            modified = { bg = mocha.yellow, fg = mocha.base },
            removed  = { bg = mocha.red,    fg = mocha.base },
          },
          separator = { left = "", right = "" },
        },
        {
          "diagnostics",
          sources  = { "nvim_lsp", "nvim_diagnostic" },
          symbols  = { error = " ", warn = " ", hint = " ", info = " " },
          diagnostics_color = {
            error = { bg = mocha.red,    fg = mocha.base },
            warn  = { bg = mocha.yellow, fg = mocha.base },
            hint  = { bg = mocha.teal,   fg = mocha.base },
            info  = { bg = mocha.blue,   fg = mocha.base },
          },
          separator = { left = "", right = "" },
        },
      },
      lualine_x = {},
      lualine_y = {
        {
          "filetype",
          icon_only = false,
          color    = { bg = mocha.teal, fg = mocha.base },
          separator = { left = "", right = "" },
          padding  = { left = 1, right = 1 },
        },
      },
      lualine_z = {
        {
          "progress",
          color    = { bg = mocha.blue, fg = mocha.base, gui = "bold" },
          separator = { left = "", right = "" },
        },
        {
          "location",
          color    = { bg = mocha.purple, fg = mocha.base, gui = "bold" },
          separator = { left = "", right = "" },
        },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
  },
}
