-- ~/.config/nvim/init.lua
-- Entry point — just loads everything else

vim.g.mapleader      = " "   -- must be set before plugins load
vim.g.maplocalleader = "\\"

vim.g.loaded_netrw       = 1  -- disable netrw so nvim-tree can take over
vim.g.loaded_netrwPlugin = 1

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.plugins")
