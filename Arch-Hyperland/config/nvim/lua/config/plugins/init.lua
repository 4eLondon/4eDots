-- ~/.config/nvim/lua/config/plugins/init.lua
-- Bootstraps lazy.nvim and loads all plugin spec files

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "config.plugins.ui" },
  { import = "config.plugins.treesitter" },
  { import = "config.plugins.lsp" },
  { import = "config.plugins.completion" },
  { import = "config.plugins.editor" },
  { import = "config.plugins.tools" },
}, {
  ui      = { border = "rounded" },
  checker = { enabled = true, notify = false },
})
