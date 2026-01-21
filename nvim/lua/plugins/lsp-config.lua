return {
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		vim.keymap.set("n", "<leader>m", ":Mason<CR>", { desc = "Open Mason" }),
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
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set(
					{ "n", "v" },
					"<leader>ca",
					vim.lsp.buf.code_action,
					vim.tbl_extend("force", opts, { desc = "Code Actions" })
				)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
				vim.keymap.set(
					"n",
					"<leader>gf",
					vim.lsp.buf.format,
					vim.tbl_extend("force", opts, { desc = "Format Current File using LSP" })
				)
			end

			local servers = { "lua_ls", "ts_ls", "ruff", "basedpyright", "jdtls", "yamlls", "clangd" }

			for _, server in ipairs(servers) do
				vim.lsp.config(server, {
					capabilities = capabilities,
					on_attach = on_attach,
				})
				vim.lsp.enable(server)
			end
		end,
	},
}
