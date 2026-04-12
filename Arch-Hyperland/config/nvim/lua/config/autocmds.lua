-- ~/.config/nvim/lua/config/autocmds.lua

-- ===============================
-- Highlight on yank
-- ===============================
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern  = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- ===============================
-- Auto reload files changed outside nvim
-- ===============================
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})

-- ===============================
-- Remove trailing whitespace on save
-- ===============================
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- ===============================
-- formatoptions per-buffer (survives ftplugin resets)
-- ===============================
vim.api.nvim_create_autocmd("BufEnter", {
  pattern  = "*",
  callback = function()
    vim.opt_local.formatoptions = "qjcro"
  end,
})

-- ===============================
-- Return to last cursor position on open
-- ===============================
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark       = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ===============================
-- Auto-create missing directories on save
-- ===============================
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(event)
    local dir = vim.fn.fnamemodify(event.match, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- ===============================
-- Filetype-specific tab widths
-- ===============================
vim.api.nvim_create_autocmd("FileType", {
  pattern  = { "c", "cpp", "cs" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop    = 4
  end,
})

-- ===============================
-- Close certain windows with q
-- ===============================
vim.api.nvim_create_autocmd("FileType", {
  pattern  = { "help", "lspinfo", "man", "checkhealth", "qf" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- ===============================
-- Filetype & syntax
-- ===============================
vim.cmd([[
  filetype plugin indent on
  syntax enable
]])
