-- ~/.config/nvim/lua/config/plugins/tools.lua
-- Telescope, file explorer, git

return {

  -- ----------------------------
  -- Fuzzy finder
  -- ----------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix        = " ",
          selection_caret      = " ",
          path_display         = { "smart" },
          file_ignore_patterns = {
            "node_modules", ".git/", "dist/", "__pycache__", "*.lock",
          },
        },
      })
      require("telescope").load_extension("fzf")

      local tb  = require("telescope.builtin")
      local map = vim.keymap.set
      map("n", "<leader>ff", tb.find_files,           { desc = "Find files" })
      map("n", "<leader>fg", tb.live_grep,            { desc = "Live grep" })
      map("n", "<leader>fb", tb.buffers,              { desc = "Buffers" })
      map("n", "<leader>fh", tb.help_tags,            { desc = "Help tags" })
      map("n", "<leader>fd", tb.diagnostics,          { desc = "Diagnostics" })
      map("n", "<leader>fr", tb.oldfiles,             { desc = "Recent files" })
      map("n", "<leader>fs", tb.lsp_document_symbols, { desc = "Document symbols" })
      map("n", "<leader>fw", tb.grep_string,          { desc = "Grep word under cursor" })
    end,
  },

  -- ----------------------------
  -- File explorer
  -- ----------------------------
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config       = function()
      require("nvim-tree").setup({
        view     = { width = 30 },
        renderer = {
          group_empty = true,
          icons       = { show = { git = true, file = true, folder = true } },
        },
        filters = { dotfiles = false },
        git     = { enable = true },
      })
      vim.keymap.set("n", "<leader>fe", ":NvimTreeToggle<CR>",   { desc = "Toggle file explorer" })
      vim.keymap.set("n", "<leader>fc", ":NvimTreeFindFile<CR>", { desc = "Find file in tree" })
    end,
  },

  -- ----------------------------
  -- Git signs + hunk controls
  -- ----------------------------
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
        },
        on_attach = function(bufnr)
          local gs  = package.loaded.gitsigns
          local map = function(mode, l, r, opts)
            opts        = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          map("n", "]c",         gs.next_hunk,    { desc = "Next hunk" })
          map("n", "[c",         gs.prev_hunk,    { desc = "Prev hunk" })
          map("n", "<leader>hs", gs.stage_hunk,   { desc = "Stage hunk" })
          map("n", "<leader>hr", gs.reset_hunk,   { desc = "Reset hunk" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>hb", gs.blame_line,   { desc = "Blame line" })
          map("n", "<leader>hd", gs.diffthis,     { desc = "Diff this" })
        end,
      })
    end,
  },

}
