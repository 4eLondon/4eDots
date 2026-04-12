-- ============================
--     PLUGIN MANAGER SETUP
-- ============================
-- Configure git to have very long timeouts (2 hours)
vim.fn.system("git config --global http.postBuffer 2147483648")
vim.fn.system("git config --global http.lowSpeedLimit 0")
vim.fn.system("git config --global http.lowSpeedTime 7200")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================
--         PLUGINS
-- ============================
require("lazy").setup({

-- vim-polyglot for syntax highlighting (Treesitter alternative)
{
  "sheerun/vim-polyglot",
  lazy = false,
  priority = 1000,
  init = function()
    -- Ensure syntax is enabled
    vim.cmd('syntax enable')
    vim.cmd('filetype plugin indent on')
  end,
},

  -- Mason for LSP/tool installation
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },


-- Everforest colorscheme
{
  "sainnhe/everforest",
  lazy = false,
  priority = 1000,
  config = function()

    -- Everforest configuration
    vim.g.everforest_background = 'hard'
    vim.g.everforest_better_performance = 1
    vim.g.everforest_enable_italic = 0
    vim.g.everforest_disable_italic_comment = 1
    vim.g.everforest_transparent_background = 2
    vim.g.everforest_dim_inactive_windows = 0
    vim.g.everforest_sign_column_background = 'none'
    vim.g.everforest_diagnostic_text_highlight = 1
    vim.g.everforest_diagnostic_line_highlight = 1
    vim.g.everforest_current_word = 'grey background'

    -- Load the colorscheme
    vim.cmd('colorscheme everforest')
  end,
},

  --[[Nord colorscheme
  { "shaunsingh/nord.nvim",
  lazy = false,
  priority = 1000,
  config = function()
-- Nord configuration
  vim.g.nord_contrast = true
  vim.g.nord_borders = false
  vim.g.nord_disable_background = true  -- This keeps your transparent background
  vim.g.nord_italic = false
  vim.g.nord_uniform_diff_background = true
  vim.g.nord_bold = false

 require('nord').set()
 end,
},
]]

  -- Mason-LSPConfig bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "rust_analyzer",
          "lua_ls",
          "pyright",
          "ts_ls",
          "html",
          "cssls",
          "jsonls",
          "marksman",
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- LSP keybindings
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Setup each LSP server using the new vim.lsp.config API
      local servers = {
        "clangd", "rust_analyzer", "pyright", 
        "ts_ls", "html", "cssls", "jsonls", "marksman"
      }

      -- Lua LS needs special config
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
        filetypes = { "lua" },
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      }

      -- Setup other servers with new API
      for _, server in ipairs(servers) do
        vim.lsp.config[server] = {}
      end

      -- Enable LSP servers on FileType
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local bufnr = args.buf
          local clients = vim.lsp.get_clients({ bufnr = bufnr })
          if #clients > 0 then
            on_attach(clients[1], bufnr)
          end
        end,
      })

      -- Auto-enable LSP on buffer enter
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          on_attach(nil, args.buf)
        end,
      })
      
      -- Enable LSP for configured servers
      vim.lsp.enable({ "lua_ls", "clangd", "rust_analyzer", "pyright", "ts_ls", "html", "cssls", "jsonls", "marksman" })
    end,
  },

  -- Which-key for keybind help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
        },
        win = {
          border = "single",
          position = "bottom",
        },
      })

      -- Register keybind groups and descriptions
      wk.add({
        { "<leader>f", group = "Find (Telescope)" },
        { "<leader>ff", desc = "Find files" },
        { "<leader>fg", desc = "Live grep" },
        { "<leader>fb", desc = "Find buffers" },
        { "<leader>fh", desc = "Help tags" },
        
        { "<leader>c", group = "Code" },
        { "<leader>ca", desc = "Code action" },
        { "<leader>rn", desc = "Rename" },
        
        { "<leader>w", desc = "Save file" },
        { "<leader>q", desc = "Quit" },
        { "<leader>h", desc = "Horizontal split" },
        { "<leader>v", desc = "Vertical split" },
        { "<leader>e", desc = "Toggle file explorer" },
        
        { "<leader>z", group = "Spell Check" },
        { "<leader>zt", desc = "Toggle spell check" },
        { "<leader>zn", desc = "Next spelling error" },
        { "<leader>zp", desc = "Previous spelling error" },
        { "<leader>zs", desc = "Suggest corrections" },
        { "<leader>za", desc = "Add word to dictionary" },
        { "<leader>zg", desc = "Add word (good)" },
        { "<leader>zw", desc = "Mark word as wrong" },
        
        { "gd", desc = "Go to definition" },
        { "gr", desc = "Go to references" },
        { "K", desc = "Hover documentation" },
        { "[d", desc = "Previous diagnostic" },
        { "]d", desc = "Next diagnostic" },
        
        { "gc", desc = "Comment toggle linewise", mode = { "n", "v" } },
        { "gb", desc = "Comment toggle blockwise", mode = { "n", "v" } },
      })
    end,
  },

  -- Autocompletion
  -- Autocompletion
{
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    -- Add HTML/CSS/emmet completion
    "dcampos/nvim-snippy",
    "dcampos/cmp-snippy",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'buffer', priority = 500 },
        { name = 'path', priority = 250 },
      }),
    })

    -- Special setup for HTML files to trigger on '<'
    cmp.setup.filetype('html', {
      sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'buffer', priority = 500, keyword_length = 2 },
        { name = 'path', priority = 250 },
      })
    })
  end,
},
    -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        check_ts = true,
        ts_config = {
          lua = {'string'},
          javascript = {'template_string'},
        }
      })
      
      -- Add rule for angle brackets
      local Rule = require('nvim-autopairs.rule')
      npairs.add_rules({
        Rule("<", ">")
      })
      
      -- Integrate with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Color visualization
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        filetypes = { "*" }, -- Enable for all filetypes
        user_default_options = {
          RGB = true,      -- #RGB hex codes
          RRGGBB = true,   -- #RRGGBB hex codes
          names = true,    -- "Name" codes like Blue, red
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          AARRGGBB = true, -- 0xAARRGGBB hex codes
          rgb_fn = true,   -- CSS rgb() and rgba() functions
          hsl_fn = true,   -- CSS hsl() and hsla() functions
          css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available modes: foreground, background, virtualtext
          mode = "background", -- Set the display mode
          tailwind = true, -- Enable tailwind colors
          sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
          virtualtext = "■",
        },
        -- all the sub-options of filetypes apply to buftypes
        buftypes = {},
      })
    end,
  },

  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Find buffers' },
      { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Help tags' },
    },
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = "|",
          section_separators = "",
        },
      })
    end,
  },

  -- Comment plugin
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Comment toggle linewise" },
      { "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
    },
    config = function()
      require("Comment").setup()
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { '<leader>e', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle file explorer' },
    },
    config = function()
      require("nvim-tree").setup()
    end,
  },
}, {
  -- Lazy.nvim options
  git = {
    timeout = 7200,
  },
  install = {
    missing = true,
  },
})
