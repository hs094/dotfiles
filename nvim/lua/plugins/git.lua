return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration
    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua",              -- optional
    "nvim-mini/mini.pick",           -- optional
  },
  config = function()
    require("diffview").setup({
      hg_cmd = nil, -- Disable Mercurial support to avoid warning
    })

    -- Git blame keymaps
    vim.keymap.seti("n", "<leader>gb", function()
      vim.cmd("Git blame")
    end, { desc = "Git blame line" })

    vim.keymap.seti("n", "<leader>gB", function()
      vim.cmd("Git blame --date=short")
    end, { desc = "Git blame buffer" })

    -- Toggle git blame
    vim.keymap.seti("n", "<leader>gt", function()
      vim.cmd("Git blame --toggle")
    end, { desc = "Toggle git blame" })

    -- Open git blame in floating window
    vim.keymap.seti("n", "<leader>gD", function()
      vim.cmd("Git blame --date=short --")
    end, { desc = "Git blame (detailed)" })

    -- Git log with graph
    vim.keymap.seti("n", "<leader>gl", function()
      vim.cmd("Git log --oneline --graph --decorate")
    end, { desc = "Git log (graph)" })

    -- Git diff
    vim.keymap.seti("n", "<leader>gd", function()
      vim.cmd("Git diff")
    end, { desc = "Git diff" })

    -- Git status
    vim.keymap.seti("n", "<leader>gs", function()
      vim.cmd("Git status")
    end, { desc = "Git status" })
  end,
}
