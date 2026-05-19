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

-- Wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 0
vim.opt.showbreak = "↪ "
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2"

-- Show hidden characters
vim.opt.list = true
vim.opt.listchars = {
    trail = "·",
    extends = "→",
    precedes = "←",
    nbsp = "␣",
}

-- Folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldenable = false
vim.opt.fillchars = {
    fold = "·",
    foldopen = "▾",
    foldclose = "▸",
    foldsep = "│",
}

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

-- Restore cursor position on open
vim.api.nvim_create_autocmd("BufReadPost", {
    desc = "Return to last cursor position when reopening a file",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.api.nvim_win_set_cursor(0, mark)
            vim.cmd("normal! zz")
        end
    end,
})

-- Auto format on save, guarded
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
            vim.lsp.buf.format({ async = false })
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

            -- C / C++
            vim.lsp.config("clangd", {
                cmd = { "clangd", "--fallback-style=none" },
                filetypes = { "c", "cpp" },
                capabilities = capabilities,
            })
            vim.lsp.enable("clangd")

            -- HTML
            vim.lsp.config("html", {
                cmd = { "vscode-html-language-server", "--stdio" },
                filetypes = { "html" },
                capabilities = capabilities,
            })
            vim.lsp.enable("html")

            -- CSS / SCSS / Less
            vim.lsp.config("cssls", {
                cmd = { "vscode-css-language-server", "--stdio" },
                filetypes = { "css", "scss", "less" },
                capabilities = capabilities,
            })
            vim.lsp.enable("cssls")

            -- JavaScript / TypeScript
            vim.lsp.config("ts_ls", {
                cmd = { "typescript-language-server", "--stdio" },
                filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                capabilities = capabilities,
            })
            vim.lsp.enable("ts_ls")

            -- Lua
            vim.lsp.config("lua_ls", {
                cmd = { "lua-language-server" },
                filetypes = { "lua" },
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        workspace = {
                            library = {
                                vim.fn.expand("$VIMRUNTIME/lua"),
                                "/usr/share/love",
                            },
                            checkThirdParty = false,
                        },
                        diagnostics = { globals = { "love" } },
                        telemetry = { enable = false },
                    },
                },
            })
            vim.lsp.enable("lua_ls")

            -- Python
            vim.lsp.config("pyright", {
                cmd = { "pyright-langserver", "--stdio" },
                filetypes = { "python" },
                capabilities = capabilities,
            })
            vim.lsp.enable("pyright")

            -- C#
            vim.lsp.config("omnisharp", {
                cmd = { "omnisharp" },
                filetypes = { "cs" },
                capabilities = capabilities,
            })
            vim.lsp.enable("omnisharp")
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-treesitter").setup({
                ensure_installed = { "c", "cpp", "html", "css", "javascript", "typescript", "lua", "python", "c_sharp" },
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

-- Diagnostics
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    float = {
        border = "rounded",
        source = true,
    },
})

-- Keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("n", "<C-a>", "ggVG")
vim.keymap.set("v", "<C-a>", "<Esc>ggVG")
vim.keymap.set("i", "<C-v>", '<Esc>"+pi')
vim.keymap.set("n", "<C-v>", '"+p')
vim.keymap.set("v", "<C-v>", '"+p')
