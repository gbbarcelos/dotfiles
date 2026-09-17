local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.number         = true
vim.opt.numberwidth    = 3
vim.opt.wrap           = true
vim.opt.linebreak      = true
vim.opt.relativenumber = false
vim.opt.termguicolors  = true
vim.opt.signcolumn     = "yes"
vim.opt.cursorline     = true
vim.opt.expandtab      = true
vim.opt.tabstop        = 2
vim.opt.shiftwidth     = 2
vim.opt.scrolloff      = 8
vim.opt.sidescrolloff  = 8
vim.opt.splitright     = true
vim.opt.splitbelow     = true
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.undofile       = true
vim.opt.updatetime     = 200
vim.opt.timeoutlen     = 300
vim.opt.mouse          = "a"
vim.opt.clipboard      = "unnamedplus"
vim.opt.completeopt    = { "menu", "menuone", "noselect" }
vim.opt.laststatus     = 3

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local function make_transparent()
  local groups = {
    "Normal", "NormalNC", "NormalFloat", "FloatBorder",
    "SignColumn", "EndOfBuffer", "TelescopeNormal",
    "TelescopeBorder", "NvimTreeNormal", "NvimTreeNormalNC",
  }
  for _, g in ipairs(groups) do
    vim.api.nvim_set_hl(0, g, { bg = "NONE", ctermbg = "NONE" })
  end
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1a1c2c" })
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = make_transparent })

local map = vim.keymap.set
map("n", "<leader>w",  "<cmd>w<cr>",      { desc = "Salvar" })
map("n", "<leader>q",  "<cmd>q<cr>",      { desc = "Fechar" })
map("n", "<Esc>",      "<cmd>noh<cr>",    { desc = "Limpar highlight" })
map("n", "<C-h>",      "<C-w>h",          { desc = "Janela ←" })
map("n", "<C-l>",      "<C-w>l",          { desc = "Janela →" })
map("n", "<C-j>",      "<C-w>j",          { desc = "Janela ↓" })
map("n", "<C-k>",      "<C-w>k",          { desc = "Janela ↑" })
map("v", "<",          "<gv",             { desc = "Indentar ←" })
map("v", ">",          ">gv",             { desc = "Indentar →" })

require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    lazy    = false,
    priority = 1000,
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
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
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
          a = { bg = mocha.purple,  fg = mocha.base,    gui = "bold" },
          b = { bg = mocha.surface0, fg = mocha.text },
          c = { bg = "NONE",        fg = mocha.subtext1 },
        },
        insert = {
          a = { bg = mocha.green,  fg = mocha.base, gui = "bold" },
          b = { bg = mocha.surface0, fg = mocha.text },
          c = { bg = "NONE",       fg = mocha.subtext1 },
        },
        visual = {
          a = { bg = mocha.teal,   fg = mocha.base, gui = "bold" },
          b = { bg = mocha.surface0, fg = mocha.text },
          c = { bg = "NONE",       fg = mocha.subtext1 },
        },
        replace = {
          a = { bg = mocha.red,    fg = mocha.base, gui = "bold" },
          b = { bg = mocha.surface0, fg = mocha.text },
          c = { bg = "NONE",       fg = mocha.subtext1 },
        },
        command = {
          a = { bg = mocha.yellow, fg = mocha.base, gui = "bold" },
          b = { bg = mocha.surface0, fg = mocha.text },
          c = { bg = "NONE",       fg = mocha.subtext1 },
        },
        inactive = {
          a = { bg = mocha.surface1, fg = mocha.subtext1 },
          b = { bg = mocha.surface0, fg = mocha.subtext1 },
          c = { bg = "NONE",         fg = mocha.subtext1 },
        },
      }

      require("lualine").setup({
        options = {
          theme                = custom_theme,
          component_separators = "",
          section_separators   = { left = "", right = "" },
          globalstatus         = true,
          disabled_filetypes   = { statusline = { "dashboard", "alpha" } },
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
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Encontrar arquivos" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",   desc = "Busca no projeto" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "Ajuda" },
    },
    opts = {
      defaults = {
        layout_config = { horizontal = { preview_width = 0.55 } },
        borderchars   = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      },
    },
  },

  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    config = true,
  },
  
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comentar linha" },
      { "gc",  mode = "v", desc = "Comentar seleção" },
    },
    config = true,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },
},

{

  ui = {
    border = "rounded",
    icons  = { cmd = "⌘", config = "🛠", event = "📡", ft = "📂", init = "⚙", keys = "🗝", plugin = "🔌", runtime = "💻", source = "📄", start = "🚀", task = "📌", lazy = "💤" },
  },
})
