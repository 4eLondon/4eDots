return {
  {
    "nvim-treesitter/nvim-treesitter",
    build  = ":TSUpdate",
    event  = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldlevel  = 99
    end,
  },
}
