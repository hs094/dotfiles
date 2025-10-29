return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "ruff", "jdtls", "clangd" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Define servers with configs (optimized: loop for setup/enable)
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" }, -- Recognize Neovim globals
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true), -- Use Neovim runtime for better completions
              },
            },
          },
        },
        ts_ls = {
          -- Covers TypeScript and JavaScript; add JS-specific if needed
        },
        ruff = {
          cmd = { "ruff", "lsp" }, -- Explicit command for Ruff 0.5.3+
          -- Astral's Ruff: Fast Python LSP for linting/formatting. Config via pyproject.toml/ruff.toml
          init_options = {
            settings = {
              args = { "--config", ".ruff.toml" }, -- Optional: Point to config file
            },
          },
        },
        jdtls = {
          -- Java: Requires JDK; Mason installs Eclipse JDT.LS
          init_options = {
            bundles = {}, -- Add extensions here if needed (e.g., for Spring)
          },
        },
        clangd = {
          -- C++: Basic setup; add compile_commands.json for better results
          cmd = { "clangd", "--background-index" }, -- Enable background indexing
        },
      }

      -- Loop to configure and enable each server
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      -- LSP keymaps are now managed in config/keymap.lua
    end,
  },
}
