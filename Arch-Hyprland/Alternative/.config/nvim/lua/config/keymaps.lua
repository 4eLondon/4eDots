-- ~/.config/nvim/lua/config/keymaps.lua

local map = vim.keymap.set

-- ===============================
-- Window navigation
-- ===============================
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- ===============================
-- Resize splits
-- ===============================
map("n", "<C-Up>",    ":resize +2<CR>")
map("n", "<C-Down>",  ":resize -2<CR>")
map("n", "<C-Left>",  ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")

-- ===============================
-- Splits
-- ===============================
map("n", "<leader>sv", ":vsplit<CR>",  { desc = "Vertical split" })
map("n", "<leader>sh", ":split<CR>",   { desc = "Horizontal split" })
map("n", "<leader>se", "<C-w>=",       { desc = "Equalize splits" })
map("n", "<leader>sc", ":close<CR>",   { desc = "Close split" })

-- ===============================
-- Buffers
-- ===============================
map("n", "<leader>bn", ":bnext<CR>",     { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>bd", ":bdelete<CR>",   { desc = "Delete buffer" })

-- ===============================
-- Files
-- ===============================
map("n", "<leader>w", ":w<CR>",                                        { desc = "Save" })
map("n", "<leader>q", ":q<CR>",                                        { desc = "Quit" })
map("n", "<leader>x", ":x<CR>",                                        { desc = "Save and quit" })
map("n", "<leader>e", ':e <C-R>=expand("%:p:h") . "/"<CR>',            { desc = "Open relative" })

-- ===============================
-- Search
-- ===============================
map("n", "<leader>/", ":nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Replace word under cursor across file
map("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace word" })

-- ===============================
-- Scrolling (centered)
-- ===============================
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- ===============================
-- Editing
-- ===============================
-- Stay in visual after indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move selected lines up/down
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Paste without overwriting clipboard
map("v", "p", '"_dP')

-- Join line without moving cursor
map("n", "J", "mzJ`z")

-- Select line without newline
map("n", "vv", "^v$h", { desc = "Select line" })

-- ===============================
-- Clipboard
-- ===============================
map("n", "<C-c>", '"+yy',       { desc = "Copy line" })
map("v", "<C-c>", '"+y',        { desc = "Copy selection" })
map("i", "<C-c>", '<Esc>"+yyi', { desc = "Copy line (insert)" })
map("n", "<C-v>", '"+p',        { desc = "Paste" })
map("i", "<C-v>", "<C-r>+",     { desc = "Paste (insert)" })

-- Select all
map("n", "<C-a>", "gg0vG$",      { desc = "Select all" })
map("i", "<C-a>", "<Esc>gg0vG$", { desc = "Select all (insert)" })

-- ===============================
-- Toggles
-- ===============================
map("n", "<leader>rn", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle relative numbers" })

map("n", "<leader>ww", function()
  vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "Toggle wrap" })

map("n", "<leader>l", function()
  vim.opt.list = not vim.opt.list:get()
end, { desc = "Toggle whitespace chars" })

-- ===============================
-- Terminal
-- ===============================
map("n", "<leader>t", ":split | terminal<CR>", { desc = "Open terminal" })

-- ===============================
-- Spellcheck
-- ===============================
map("n", "<leader>sp", ":setlocal spell! spelllang=en_us<CR>", { desc = "Toggle spellcheck" })

-- ===============================
-- Quickfix
-- ===============================
map("n", "<leader>co", ":copen<CR>",  { desc = "Open quickfix" })
map("n", "<leader>cc", ":cclose<CR>", { desc = "Close quickfix" })
map("n", "<leader>cn", ":cnext<CR>",  { desc = "Next quickfix" })
map("n", "<leader>cp", ":cprev<CR>",  { desc = "Prev quickfix" })

-- ===============================
-- Diagnostics
-- ===============================
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "[d",         vim.diagnostic.goto_prev,  { desc = "Prev diagnostic" })
map("n", "]d",         vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- ===============================
-- Auto-pairs (markup filetypes only for <>)
-- ===============================
vim.api.nvim_create_autocmd("FileType", {
  pattern  = { "html", "xml", "jsx", "tsx", "svelte", "vue" },
  callback = function()
    vim.keymap.set("i", "<", "<><Left>", { buffer = true })
  end,
})
