return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = {
			{ "<leader>m", "<cmd>Mason<cr>", desc = "Open Mason" },
		},
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
		opts = {
			ensure_installed = {
				-- Core languages
				"lua_ls", -- Neovim Lua runtime completion
				"jdtls", -- Eclipse JDT LS for full Java IDE support
				"clangd", -- Fast C/C++ indexing and diagnostics
				"basedpyright", -- Modern Python LS (swap with "pyright" if you prefer)
				"ruff", -- Ultra-fast Python linter/formatter
				"rust_analyzer", -- First-class Rust experience
				"gopls", -- Official Go language server

				-- JS/TS ecosystem (covers React / Next.js)
				"ts_ls", -- Handles JS/TS/React/Next.js files
				"eslint", -- JS/TS linting and fixes
				"tailwindcss", -- Tailwind CSS IntelliSense

				-- DevOps / Config files
				"dockerls", -- Dockerfile support
				"docker_compose_language_service", -- Docker Compose support
				"yamlls", -- YAML files (Kubernetes, GitHub Actions, ...)
				"jsonls", -- JSON schema validation (package.json, tsconfig.json, ...)

				-- Nice extras
				"marksman", -- Markdown & MDX docs
				"bashls", -- Shell scripts

				-- Optional add-ons (enable if your stack needs them)
				"sqls", -- SQL databases
				"prismals", -- Prisma ORM schema files
				"graphql", -- GraphQL SDL + query tooling
			},
			automatic_installation = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- Add foldingRange capability for nvim-ufo
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			local on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, silent = true }
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				-- gD, gr handled by Snacks pickers (lsp_declarations / lsp_references)
				vim.keymap.set(
					{ "n", "v" },
					"<leader>ca",
					vim.lsp.buf.code_action,
					vim.tbl_extend("force", opts, { desc = "Code Actions" })
				)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, opts)
				vim.keymap.set("n", "]d", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, opts)
				vim.keymap.set(
					"n",
					"<leader>cd",
					vim.diagnostic.open_float,
					vim.tbl_extend("force", opts, { desc = "Show line diagnostic" })
				)
				vim.keymap.set("n", "<leader>D", vim.diagnostic.setloclist, opts)
				vim.keymap.set(
					"n",
					"<leader>gf",
					vim.lsp.buf.format,
					vim.tbl_extend("force", opts, { desc = "Format Current File using LSP" })
				)
			end

			local servers = {
				-- Core languages
				"lua_ls",
				"jdtls",
				"basedpyright",
				"ruff",
				"rust_analyzer",
				"gopls",
				-- JS/TS ecosystem
				"ts_ls",
				"eslint",
				"tailwindcss",
				-- DevOps / config
				"dockerls",
				"docker_compose_language_service",
				"yamlls",
				"jsonls",
				-- Extras
				"marksman",
				"bashls",
				"sqls",
				"prismals",
				"graphql",
			}

			for _, server in ipairs(servers) do
				vim.lsp.config(server, {
					capabilities = capabilities,
					on_attach = on_attach,
				})
				vim.lsp.enable(server)
			end

			vim.lsp.config("clangd", {
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = {
					"clangd",
					"--offset-encoding=utf-16",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
				},
				root_dir = vim.fs.dirname(vim.fs.find({ ".git", "compile_commands.json" }, { upward = true })[1]),
				single_file_support = true,
				init_options = {
					clangdFileStatus = true,
					useColorHighlighting = true,
					completeUnimported = true,
					headerInsertion = "never",
				},
			})
			vim.lsp.enable("clangd")
		end,
	},
}
