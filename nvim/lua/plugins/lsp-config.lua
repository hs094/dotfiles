return {
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'ast_grep',
                    'docker_compose_language_service'
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp" },  -- Ensure cmp-nvim-lsp is installed
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require('cmp_nvim_lsp').default_capabilities()  -- ✅ Corrected

            -- Configure LSP servers
            local servers = { "lua_ls", "ts_ls", "html", "pyright", "jdtls", "clangd" }
            for _, server in ipairs(servers) do
                lspconfig[server].setup({
                    capabilities = capabilities
                })
            end

            -- Keybindings for LSP
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "LSP Hover" })
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
            vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, { desc = "Code Action" })
        end
    }
}
