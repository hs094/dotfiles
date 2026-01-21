return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
			"jay-babu/mason-nvim-dap.nvim",
		},
		lazy = false,
		priority = 100,
		cmd = { "DapInstall", "DapUiOpen", "DapUiToggle" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local dapvirt = require("nvim-dap-virtual-text")

			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.30 },
							{ id = "breakpoints", size = 0.20 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 50,
						position = "left",
					},
					{
						elements = {
							"repl",
							"console",
						},
						size = 15,
						position = "bottom",
					},
				},
				floating = {
					border = "rounded",
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
				controls = {
					enabled = true,
					element = "repl",
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						terminate = "⏹",
					},
				},
			})

			dapvirt.setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				fade_in_variables = false,
				show_stop_reason = true,
				commented = true,
				only_first_definition = false,
				all_references = false,
				virt_lines = false,
				virt_text_win_col = nil,
			})

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.after.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.after.event_exited["dapui_config"] = function()
				dapui.close()
			end

			dap.adapters.python = {
				type = "executable",
				command = "python",
				args = { "-m", "debugpy.adapter" },
			}

			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = function()
						local venv = os.getenv("VIRTUAL_ENV")
						if venv then return venv .. "/bin/python" end
						return "/usr/bin/python3"
					end,
				},
				{
					type = "python",
					request = "attach",
					name = "Remote Debug",
					host = "127.0.0.1",
					port = 5678,
					pythonPath = function()
						local venv = os.getenv("VIRTUAL_ENV")
						if venv then return venv .. "/bin/python" end
						return "/usr/bin/python3"
					end,
				},
				{
					type = "python",
					request = "launch",
					name = "Launch with Arguments",
					program = "${file}",
					args = function()
						local args_str = vim.fn.input("Arguments: ")
						return vim.split(args_str, " ")
					end,
					pythonPath = function()
						local venv = os.getenv("VIRTUAL_ENV")
						if venv then return venv .. "/bin/python" end
						return "/usr/bin/python3"
					end,
				},
			}

			dap.adapters.pwa_node = {
				type = "server",
				host = "127.0.0.1",
				port = "${port}",
				spawn = {
					command = "node",
					args = {
						vim.fn.expand("$MASON/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"),
						"${port}",
					},
				},
			}

			dap.configurations.typescript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch TypeScript",
					program = "${file}",
					cwd = "${workspaceFolder}",
					runtimeExecutable = "ts-node",
					runtimeArgs = { "-r", "tsconfig-paths/register" },
					sourceMaps = true,
					skipFiles = { "<node_internals>/**" },
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach to Node Process",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					skipFiles = { "<node_internals>/**" },
				},
			}

			dap.configurations.javascript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch JavaScript",
					program = "${file}",
					cwd = "${workspaceFolder}",
					runtimeExecutable = "node",
					sourceMaps = true,
					skipFiles = { "<node_internals>/**" },
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach to Node Process",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					skipFiles = { "<node_internals>/**" },
				},
			}

			dap.adapters.lldb = {
				type = "executable",
				command = "lldb",
				name = "lldb",
			}

			dap.adapters.codelldb = {
				type = "server",
				port = "13000",
				executable = {
					command = "codelldb",
					args = { "--port", "13000" },
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.expand("%:p:h") .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = true,
					args = {},
					env = {},
					runInTerminal = false,
				},
				{
					name = "Attach to Process",
					type = "lldb",
					request = "attach",
					pid = require("dap.utils").pick_process,
					args = {},
				},
				{
					name = "Debug Rust",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.expand("%:p:h") .. "/target/debug/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp

			dap.adapters.java = {
				type = "executable",
				command = "javadbg",
				args = { "-i", "true", "-d", "5005" },
			}

			dap.configurations.java = {
				{
					name = "Debug Java (Launch)",
					type = "java",
					request = "launch",
					hostName = "127.0.0.1",
					port = 5005,
				},
				{
					name = "Debug Java (Attach)",
					type = "java",
					request = "attach",
					hostName = "127.0.0.1",
					port = 5005,
				},
			}

			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
			vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "Pause" })
			vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
			vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })

			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Set Conditional Breakpoint" })
			vim.keymap.set("n", "<leader>dL", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, { desc = "Set Log Point" })
			vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
			vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
			vim.keymap.set("n", "<leader>dv", dapvirt.toggle, { desc = "Toggle Virtual Text" })
			vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last Configuration" })
			vim.keymap.set("n", "<leader>dk", dap.up, { desc = "Move Up Stack Frame" })
			vim.keymap.set("n", "<leader>dj", dap.down, { desc = "Move Down Stack Frame" })
			vim.keymap.set("n", "<leader>dH", dap.clear_breakpoints, { desc = "Clear All Breakpoints" })
			vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "Terminate Debug Session" })
			vim.keymap.set("n", "<leader>dw", dap.eval, { desc = "Evaluate Word Under Cursor" })
			vim.keymap.set("v", "<leader>dw", dap.visual_eval, { desc = "Evaluate Visual Selection" })
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = {
			automatic_installation = {
				enable = true,
				ui = {
					icons = {
						server_installed = "✓",
						server_pending = "➜",
						server_uninstalled = "✗",
					},
				},
			},
			handlers = {
				python = function(config)
					config.adapters = {
						type = "executable",
						command = "python",
						args = { "-m", "debugpy.adapter" },
					}
					return config
				end,
				js_debug = function(config)
					config.adapters = {
						type = "server",
						host = "127.0.0.1",
						port = "${port}",
					}
					return config
				end,
			},
			ensure_installed = {
				"python",
				"codelldb",
				"js-debug-adapter",
				"java-debug-adapter",
				"javadbg",
			},
		},
	},
}
