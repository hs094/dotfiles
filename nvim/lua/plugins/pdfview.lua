return {
  "basola21/PDFview",
  lazy = false, -- Load plugin on startup
  config = function()
    local map = vim.keymap.set

    -- Open PDFview manually
    map("n", "<leader>pv", ":PDFview<CR>", { desc = "PDFview: Open PDF", noremap = true, silent = true })

    -- Navigate to the next page in the PDF
    map("n", "<leader>jj", "<cmd>lua require('pdfview.renderer').next_page()<CR>", { desc = "PDFview: Next page", noremap = true, silent = true })

    -- Navigate to the previous page in the PDF
    map("n", "<leader>kk", "<cmd>lua require('pdfview.renderer').previous_page()<CR>", { desc = "PDFview: Previous page", noremap = true, silent = true })

    -- Optional: Add mappings automatically for TeX files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "tex",
      callback = function()
        map("n", "<leader>pv", ":PDFview<CR>", { desc = "PDFview: Open PDF", noremap = true, silent = true, buffer = true })
      end,
    })
  end,
}
