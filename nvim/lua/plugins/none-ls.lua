return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- Lua formatting
        null_ls.builtins.formatting.stylua,
        -- Spell completion
        null_ls.builtins.completion.spell,
        -- Python formatting with ruff
        null_ls.builtins.formatting.ruff,
        -- Python completions with ruff
        null_ls.builtins.completion.ruff,
        -- Python import sorting
        null_ls.builtins.formatting.isort,
        -- ESLint diagnostics are not available in the standard none-ls.nvim
        -- If you need ESLint, consider using nvim-lspconfig with eslint-lsp
        -- or install none-ls-extras.nvim for additional sources
      },
    })
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {desc = 'Apply Formatting using the LSP Installed'})
  end,
}
