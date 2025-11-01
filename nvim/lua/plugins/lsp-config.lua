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
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Enhanced capabilities for better code actions and formatting
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.codeAction = {
        dynamicRegistration = true,
        codeActionLiteralSupport = {
          codeActionKind = {
            valueSet = {
              "",
              "quickfix",
              "refactor",
              "refactor.extract",
              "refactor.inline",
              "refactor.rewrite",
              "source",
              "source.organizeImports",
            },
          },
        },
      }

      -- LSP handlers for better error messages
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = "rounded" }
      )

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = "rounded" }
      )

      -- Define diagnostic signs
      local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = "󰋽 " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Configure diagnostic signs and display
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 4,
        },
        signs = {
          active = signs,
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- Define servers with configs
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
              },
              format = {
                enable = true,
              },
            },
          },
        },
        ts_ls = {
          settings = {
            typescript = {
              format = {
                enable = true,
              },
            },
            javascript = {
              format = {
                enable = true,
              },
            },
          },
        },
        ruff = {
          cmd = { "ruff", "lsp" },
          init_options = {
            settings = {
              args = {},
            },
          },
        },
        jdtls = {
          init_options = {
            bundles = {},
          },
        },
        clangd = {
          cmd = { "clangd", "--background-index" },
        },
      }

      -- Shared on_attach function for all servers
      local on_attach = function(client, bufnr)
        -- Enable format on save for supported clients (optional - can be disabled)
        -- Uncomment the following block if you want format on save:
        --[[
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
        --]]

        -- Highlight document symbol references
        if client.supports_method("textDocument/documentHighlight") then
          local highlight_augroup = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
          vim.api.nvim_create_autocmd("CursorHold", {
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
            group = highlight_augroup,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
            group = highlight_augroup,
          })
        end
      end

      -- Setup each server
      -- Note: Using require("lspconfig") which is deprecated but still works
      -- The new vim.lsp.config API will be available in nvim-lspconfig v3.0.0
      for server, config in pairs(servers) do
          config.capabilities = capabilities
          config.on_attach = on_attach

          vim.lsp.config(server, config)
          vim.lsp.enable(server)
      end

      -- LSP keymaps
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {
        desc = 'Show LSP hover information'
      })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
        desc = 'Go to definition'
      })
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
        desc = 'Go to declaration'
      })
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {
        desc = 'Go to implementation'
      })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, {
        desc = 'Show references'
      })
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {
        desc = 'Show LSP code actions'
      })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {
        desc = 'Rename symbol with LSP'
      })

      -- Diagnostics navigation
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {
        desc = 'Go to previous diagnostic'
      })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {
        desc = 'Go to next diagnostic'
      })
      vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, {
        desc = 'Show diagnostic in floating window'
      })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, {
        desc = 'Show diagnostics in location list'
      })

      -- Formatting keymap (smart formatting that uses LSP or null-ls)
      vim.keymap.set({ 'n', 'v' }, '<leader>gf', function()
        local bufnr = vim.api.nvim_get_current_buf()
        -- Try LSP formatting first
        local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        local has_formatter = false
        for _, client in ipairs(clients) do
          if client.supports_method("textDocument/formatting") then
            has_formatter = true
            vim.lsp.buf.format({
              async = false,
              filter = function(c)
                return c.id == client.id
              end,
            })
            break
          end
        end
        -- Fallback to null-ls if LSP doesn't support formatting
        if not has_formatter then
          local ok, null_ls = pcall(require, "null-ls")
          if ok then
            local filetype = vim.bo[bufnr].filetype
            local sources = null_ls.get_sources()
            local has_null_formatter = false
            for _, source in ipairs(sources) do
              local supports_filetype = false
              if source.filetypes then
                for _, ft in ipairs(source.filetypes) do
                  if ft == filetype then
                    supports_filetype = true
                    break
                  end
                end
              end
              if supports_filetype and source.method == null_ls.methods.FORMATTING then
                has_null_formatter = true
                break
              end
            end
            if has_null_formatter then
              null_ls.format({
                bufnr = bufnr,
                async = false,
              })
            else
              vim.notify("No formatter available for this file type (" .. filetype .. ")", vim.log.levels.WARN)
            end
          else
            vim.notify("No formatter available for this file type", vim.log.levels.WARN)
          end
        end
      end, {
        desc = 'Format code using LSP or null-ls'
      })
    end,
  },
}
