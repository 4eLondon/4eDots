-- ~/.config/nvim/lua/config/plugins/editor.lua
-- Autopairs, surround, commenting, better-escape, formatter

return {

  -- ----------------------------
  -- Autopairs (bracket/quote pairing)
  -- ----------------------------
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts         = true,
        ts_config        = {
          lua        = { "string" },
          javascript = { "template_string" },
        },
        disable_filetype = { "TelescopePrompt" },
        fast_wrap = {
          map     = "<A-e>",
          chars   = { "{", "[", "(", '"', "'" },
          end_key = "$",
          keys    = "qwertyuiopzxcvbnmasdfghjkl",
        },
      })
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ----------------------------
  -- Surround (ys, cs, ds)
  -- ----------------------------
  {
    "kylechui/nvim-surround",
    version = "*",
    event   = "VeryLazy",
    config  = function()
      require("nvim-surround").setup()
    end,
  },

  -- ----------------------------
  -- Commenting (gcc / gc)
  -- ----------------------------
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
      vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })
      vim.keymap.set("v", "<leader>/", "gc",  { remap = true, desc = "Toggle comment" })
    end,
  },

  -- ----------------------------
  -- Better escape (jk to exit insert)
  -- ----------------------------
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup({
        default_mappings = false,
        mappings = {
          i = { j = { k = "<Esc>" } },
        },
      })
    end,
  },

  -- ----------------------------
  -- Formatter (format on save)
  -- ----------------------------
  {
    "stevearc/conform.nvim",
    event  = "BufWritePre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          cs         = { "csharpier" },
          cpp        = { "clang_format" },
          c          = { "clang_format" },
          html       = { "prettier" },
          css        = { "prettier" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          json       = { "prettier" },
          markdown   = { "prettier" },
          yaml       = { "prettier" },
          lua        = { "stylua" },
          xml        = { "xmlformat" },
        },
        format_on_save = {
          timeout_ms   = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

}
