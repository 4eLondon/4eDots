-- ~/.config/nvim/lua/config/options.lua

-- ===============================
-- General
-- ===============================
vim.opt.number         = true
vim.opt.relativenumber = false
vim.opt.cursorline     = true
vim.opt.termguicolors  = true
vim.opt.scrolloff      = 8
vim.opt.signcolumn     = "yes"
vim.opt.updatetime     = 300
vim.opt.timeoutlen     = 500
vim.opt.splitright     = true
vim.opt.splitbelow     = true
vim.opt.swapfile       = false
vim.opt.backup         = false
vim.opt.completeopt    = { "menuone", "noinsert", "noselect" }

-- ===============================
-- Indentation
-- ===============================
vim.opt.expandtab      = true
vim.opt.shiftwidth     = 2
vim.opt.tabstop        = 2
vim.opt.smartindent    = true

-- ===============================
-- Wrapping
-- ===============================
vim.opt.wrap           = true
vim.opt.linebreak      = true
vim.opt.breakindent    = true

-- ===============================
-- Search
-- ===============================
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.clipboard      = "unnamedplus"

-- ===============================
-- Whitespace visibility
-- ===============================
vim.opt.list           = true
vim.opt.listchars      = {
  tab      = "→ ",
  trail    = "·",
  lead     = "·",
  extends  = "»",
  precedes = "«",
  nbsp     = "␣",
}

-- ===============================
-- Persistent undo
-- ===============================
local undodir          = vim.fn.stdpath("config") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
vim.opt.undofile       = true
vim.opt.undodir        = undodir

-- ===============================
-- Folds (treesitter sets expr after loading)
-- ===============================
vim.opt.foldmethod     = "indent"
vim.opt.foldlevel      = 99

-- ===============================
-- Statusline / Tabline
-- ===============================
vim.opt.laststatus     = 3
vim.opt.showmode       = false
vim.opt.ruler          = true
vim.opt.showtabline    = 2

-- ===============================
-- Wildmenu
-- ===============================
vim.opt.wildmenu       = true
vim.opt.wildmode       = "longest:full,full"

-- ===============================
-- Session
-- ===============================
vim.opt.sessionoptions = "buffers,curdir,tabpages,globals,folds,help"

-- ===============================
-- Misc
-- ===============================
vim.opt.backspace      = { "indent", "eol", "start" }
vim.opt.whichwrap:append("<>[]hl")
vim.opt.iskeyword:append("-")

-- ===============================
-- Leader key (must be before plugins)
-- ===============================
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

-- ===============================
-- Remove background (terminal transparency)
-- ===============================
vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])

-- Remove background (terminal transparency)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern  = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  end,
})
