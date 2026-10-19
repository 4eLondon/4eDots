-- ~/.config/nvim/lua/config/plugins/ui.lua
-- Colorscheme, statusline, bufferline, indent guides, which-key, colorizer

return {

  -- ----------------------------
  -- Colorscheme
  -- ----------------------------
  --[[
  {
    "folke/tokyonight.nvim",
    lazy     = false,
    priority = 1000,
    config   = function()
      require("tokyonight").setup({ style = "night" })
      vim.cmd("colorscheme tokyonight")
    end,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({ variant = "moon" })
      vim.cmd("colorscheme rose-pine-moon")
    end,
  },

  {
    "EdenEast/nightfox.nvim",
    config = function()
      vim.cmd("colorscheme duskfox")
    end,
  },
  {
    "sainnhe/everforest",
    lazy     = false,
    priority = 1000,
    config   = function()
      vim.g.everforest_background = "medium"
      vim.g.everforest_better_performance = 1
      vim.cmd("colorscheme everforest")
    end,
  },
  ]] --
  {
    "savq/melange-nvim",
    lazy     = false,
    priority = 1000,
    config   = function()
      vim.opt.background = "dark"
      vim.cmd("colorscheme melange")
    end,
  },
  -- ----------------------------
  -- Color preview (hex, rgb, hsl, named)
  -- ----------------------------
  {
    "NvChad/nvim-colorizer.lua",
    event  = "BufReadPre",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB      = true,
          RRGGBB   = true,
          names    = true,
          RRGGBBAA = true,
          rgb_fn   = true,
          hsl_fn   = true,
          css      = true,
          css_fn   = true,
          mode     = "background",
        },
      })
    end,
  },

  -- ----------------------------
  -- Statusline
  -- ----------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config       = function()
      require("lualine").setup({
        options = {
          theme                = "auto",
          globalstatus         = true,
          component_separators = { left = "", right = "" },
          section_separators   = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- ----------------------------
  -- Bufferline (buffer tabs)
  -- ----------------------------
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config       = function()
      require("bufferline").setup({
        options = {
          mode                    = "buffers",
          separator_style         = "slant",
          show_close_icon         = false,
          show_buffer_close_icons = true,
          diagnostics             = "nvim_lsp",
          offsets                 = {
            { filetype = "NvimTree", text = "Files", text_align = "center" },
          },
        },
      })
    end,
  },

  -- ----------------------------
  -- Indent guides
  -- ----------------------------
  {
    "lukas-reineke/indent-blankline.nvim",
    main   = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope  = { enabled = true },
      })
    end,
  },

  -- ----------------------------
  -- Which-key (keybind hints)
  -- ----------------------------
  {
    "folke/which-key.nvim",
    event  = "VeryLazy",
    config = function()
      require("which-key").setup({ delay = 500 })
    end,
  },

}
