require('plugins')

-- ============================
-- 	  BASIC OPTIONS	
-- ============================

-- UI
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars = { tab = '→ ', trail = '·', nbsp = '␣' }

-- Editing
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = false

-- Misc/QoL
vim.opt.clipboard = 'unnamedplus'
vim.opt.iskeyword:append('-')
vim.opt.showcmd = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hidden = true
-- Enable syntax highlighting
vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')

-- Windows/tabs
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.autowrite = true

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Transparent background
vim.cmd('highlight Normal guibg=NONE ctermbg=NONE')


-- ============================
-- 	  SPELL CHECKING
-- ============================

-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
  end,
})


-- ============================
--   DISABLE AUTO COMMENTS
-- ============================

-- Disable automatic comment continuation
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Also set it globally
vim.opt.formatoptions:remove({ "c", "r", "o" })


-- ============================
--	    PRESISTENT UNDO
-- ============================

vim.opt.undofile = true

vim.opt.undodir = vim.fn.stdpath('data') .. '/undo'
local undo_dir = vim.fn.stdpath('data') .. '/undo'
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, 'p')
end


-- ============================
--	     AUTO SAVE
-- ============================
vim.api.nvim_create_autocmd('FocusLost', {
  callback = function()
    vim.cmd('silent! wa')
  end
})


-- ============================
-- 	    KEYBINDS
-- ============================

vim.g.mapleader = '\\'

-- Editing
vim.keymap.set('n', '<C-a>', 'ggVG') -- Select All
vim.keymap.set('v', '<C-c>', '"+y') -- Copy
vim.keymap.set('n', '<C-v>', '"+p') -- Paste
vim.keymap.set('i', '<C-v>', '<C-r>+') -- Paste
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' }) -- Save
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' }) -- Quit
vim.keymap.set('n', '<Esc>', ':noh<CR>')  -- Clear search highlight
vim.keymap.set('n', 'vv', 'V', { noremap = true, silent = true, desc = 'Select entire line' })

-- Windows/Tabs
vim.keymap.set('n', '<C-h>', '<C-w>h')  -- Navigate left
vim.keymap.set('n', '<C-j>', '<C-w>j')  -- Navigate down
vim.keymap.set('n', '<C-k>', '<C-w>k')  -- Navigate up
vim.keymap.set('n', '<C-l>', '<C-w>l')  -- Navigate right
vim.keymap.set('n', '<leader>h', ':split<CR>')  -- Horizontal split
vim.keymap.set('n', '<leader>v', ':vsplit<CR>') -- Vertical split

-- Spell check keybinds (using <leader>z)
vim.keymap.set('n', '<leader>zt', ':setlocal spell!<CR>', { desc = 'Toggle spell check' })
vim.keymap.set('n', '<leader>zn', ']s', { desc = 'Next spelling error' })
vim.keymap.set('n', '<leader>zp', '[s', { desc = 'Previous spelling error' })
vim.keymap.set('n', '<leader>zs', 'z=', { desc = 'Suggest corrections' })
vim.keymap.set('n', '<leader>za', 'zg', { desc = 'Add word to dictionary' })
vim.keymap.set('n', '<leader>zg', 'zg', { desc = 'Add word (good)' })
vim.keymap.set('n', '<leader>zw', 'zw', { desc = 'Mark word as wrong' })

