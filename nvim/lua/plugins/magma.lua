return {
  {
    "dccsillag/magma-nvim",
    build = ":UpdateRemotePlugins",
    lazy = false,
    init = function()
      -- Optional: Automatically open the output window when evaluating code
      vim.g.magma_automatically_open_output = true
    end,
    config = function()
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true, desc = "" }

      -- Evaluate the current line
      map("n", "<leader>ml", ":MagmaEvaluateLine<CR>", vim.tbl_extend("force", opts, { desc = "Magma: Evaluate Line" }))

      -- Evaluate the selected text
      map("x", "<leader>m", ":<C-u>MagmaEvaluateVisual<CR>", vim.tbl_extend("force", opts, { desc = "Magma: Evaluate Visual" }))

      -- Evaluate using operator
      map("n", "<leader>m", function()
        vim.cmd("MagmaEvaluateOperator")
      end, vim.tbl_extend("force", opts, { desc = "Magma: Evaluate Operator" }))

      -- Reevaluate the current cell
      map("n", "<leader>mc", ":MagmaReevaluateCell<CR>", vim.tbl_extend("force", opts, { desc = "Magma: Reevaluate Cell" }))

      -- Enter the output window
      map("n", "<leader>mo", ":noautocmd MagmaEnterOutput<CR>", vim.tbl_extend("force", opts, { desc = "Magma: Enter Output" }))

      -- Initialize Magma with a specific kernel
      map("n", "<leader>mi", ":MagmaInit<CR>", vim.tbl_extend("force", opts, { desc = "Magma: Initialize Kernel" }))

      -- Deinitialize Magma
      map("n", "<leader>md", ":MagmaDeinit<CR>", vim.tbl_extend("force", opts, { desc = "Magma: Deinitialize Kernel" }))
    end,
  },
}
