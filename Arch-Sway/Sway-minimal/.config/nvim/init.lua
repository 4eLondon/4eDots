-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Basic options
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Transparent background
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  end,
})
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

-- Persistent undo history
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undolevels = 10000

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- ╔══════════════════════════════════════╗
-- ║   Restore cursor position on open   ║
-- ╚══════════════════════════════════════╝
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Return to last cursor position when reopening a file",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      -- Center the screen on the restored position
      vim.cmd("normal! zz")
    end
  end,
})

-- Plugins
require("lazy").setup({
  -- Autocompletion
  { "hrsh7th/cmp-nvim-lsp" },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = { { name = "nvim_lsp" } },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- ── C / C++ ────────────────────────────────────────────────────
      vim.lsp.config("clangd", {
        cmd = { "clangd" },
        filetypes = { "c", "cpp" },
        capabilities = capabilities,
      })
      vim.lsp.enable("clangd")

      -- ── HTML ───────────────────────────────────────────────────────
      -- Install: npm i -g vscode-langservers-extracted
      vim.lsp.config("html", {
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html" },
        capabilities = capabilities,
      })
      vim.lsp.enable("html")

      -- ── CSS / SCSS / Less ──────────────────────────────────────────
      -- Install: npm i -g vscode-langservers-extracted  (same package)
      vim.lsp.config("cssls", {
        cmd = { "vscode-css-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
        capabilities = capabilities,
      })
      vim.lsp.enable("cssls")

      -- ── JavaScript / TypeScript ────────────────────────────────────
      -- Install: npm i -g typescript typescript-language-server
      vim.lsp.config("ts_ls", {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        capabilities = capabilities,
      })
      vim.lsp.enable("ts_ls")
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "c", "cpp", "html", "css", "javascript", "typescript" },
        highlight = { enable = true },
      })
    end,
  },

  -- Auto close brackets
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
})

-- Keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "K",  vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

-- Ctrl+C = copy, Ctrl+V = paste, Ctrl+A = select all
vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("n", "<C-a>", "ggVG")
vim.keymap.set("v", "<C-a>", "<Esc>ggVG")
vim.keymap.set("i", "<C-v>", '<Esc>"+pi')
vim.keymap.set("n", "<C-v>", '"+p')
vim.keymap.set("v", "<C-v>", '"+p')
