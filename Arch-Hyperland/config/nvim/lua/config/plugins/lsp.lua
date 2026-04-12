-- ~/.config/nvim/lua/config/plugins/lsp.lua
-- Uses vim.lsp.config (Neovim 0.11+ native API, replaces require('lspconfig'))

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason.nvim",
        config = function()
          require("mason").setup({ ui = { border = "rounded" } })
        end,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        config = function()
          require("mason-lspconfig").setup({
            ensure_installed = {
              "omnisharp", -- C#
              "clangd",    -- C / C++
              "html",      -- HTML
              "cssls",     -- CSS
              "ts_ls",     -- JS / TS
              "jsonls",    -- JSON
              "marksman",  -- Markdown
              "yamlls",    -- YAML
              "lua_ls",    -- Lua
              "lemminx",   -- XML
            },
            automatic_installation = true,
          })
        end,
      },
    },
    config = function()
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
      end

      -- ==============================
      -- Simple servers (no extra config)
      -- ==============================
      for _, server in ipairs({ "html", "cssls", "ts_ls", "jsonls", "marksman", "lemminx" }) do
        vim.lsp.config(server, {
          capabilities = capabilities,
          on_attach    = on_attach,
        })
        vim.lsp.enable(server)
      end

      -- ==============================
      -- Lua with LÖVE2D support
      -- ==============================

      -- First, ensure LÖVE2D types are available
      -- Run this command to download them if you haven't already:
      -- git clone https://github.com/LuaCATS/love2d.git ~/.local/share/LuaAddons/love2d

      local love2d_path = vim.fn.expand("$HOME/.local/share/LuaAddons/love2d/library")

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_attach    = on_attach,
        settings     = {
          Lua = {
            runtime = {
              -- Use LuaJIT for LÖVE2D compatibility
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" }
            },
            workspace = {
              checkThirdParty = false,
              library = vim.tbl_filter(function(path)
                return path ~= ""
              end, {
                -- Add LÖVE2D types if they exist
                vim.fn.isdirectory(love2d_path) == 1 and love2d_path or nil,
                -- You can also use the built-in path
                "${3rd}/love2d/library",
                -- Keep Neovim runtime for your config files
                vim.fn.expand("$VIMRUNTIME/lua"),
              }),
            },
            telemetry = {
              enable = false
            },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      -- ==============================
      -- C / C++
      -- ==============================
      vim.lsp.config("clangd", {
        capabilities = capabilities,
        on_attach    = on_attach,
        cmd          = { "clangd", "--background-index", "--clang-tidy" },
      })
      vim.lsp.enable("clangd")

      -- ==============================
      -- C#
      -- ==============================
      vim.lsp.config("omnisharp", {
        capabilities = capabilities,
        on_attach    = on_attach,
        cmd          = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
        settings     = {
          FormattingOptions       = { EnableEditorConfigSupport = true },
          RoslynExtensionsOptions = { EnableAnalyzersSupport = true },
        },
      })
      vim.lsp.enable("omnisharp")

      -- ==============================
      -- YAML with common schemas
      -- ==============================
      vim.lsp.config("yamlls", {
        capabilities = capabilities,
        on_attach    = on_attach,
        settings     = {
          yaml = {
            schemas    = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://json.schemastore.org/docker-compose.json"]  = "docker-compose*.yml",
            },
            validate   = true,
            completion = true,
            hover      = true,
          },
        },
      })
      vim.lsp.enable("yamlls")

      -- ==============================
      -- Diagnostics display
      -- ==============================
      vim.diagnostic.config({
        virtual_text     = true,
        signs            = true,
        underline        = true,
        update_in_insert = false,
        severity_sort    = true,
        float            = {
          border = "rounded",
          source = "always",
        },
      })

      local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
}
