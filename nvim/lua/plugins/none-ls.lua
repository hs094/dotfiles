return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lspconfig",
  },
  config = function()
    local null_ls = require("null-ls")
    
    -- Configure null-ls with both formatting and diagnostics
    null_ls.setup({
      sources = {
        -- Lua formatting
        null_ls.builtins.formatting.stylua,
        
        -- Python formatting and linting
        null_ls.builtins.formatting.ruff,
        null_ls.builtins.diagnostics.ruff,
        null_ls.builtins.formatting.isort,
        
        -- JavaScript/TypeScript formatting (fallback when tsserver doesn't format)
        null_ls.builtins.formatting.prettier.with({
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc", "css", "scss", "html", "markdown", "yaml", "toml" },
        }),
        
        -- Spell completion
        null_ls.builtins.completion.spell,
        
        -- Shell formatting
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.diagnostics.shellcheck,
        
        -- Markdown formatting
        null_ls.builtins.formatting.markdownlint,
      },
      -- Ensure null-ls integrates with LSP diagnostics
      on_attach = function(client, bufnr)
        -- This will be called when null-ls attaches to a buffer
        -- LSP keymaps are handled in plugins/lsp-config.lua
      end,
    })
  end,
}
