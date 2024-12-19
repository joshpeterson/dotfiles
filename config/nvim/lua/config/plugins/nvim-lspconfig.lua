return {
	{
		-- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			'saghen/blink.cmp',
			'j-hui/fidget.nvim',
			{
				'folke/lazydev.nvim',
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		opts = {

			servers = {
				lua_ls = {},
				clangd = {}
			}
		},
		config = function(_, opts)
			local lspconfig = require('lspconfig')
			for server, config in pairs(opts.servers) do
				config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)
			end
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then return end

					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local nmap = function(keys, func, desc)
						if desc then
							desc = 'LSP: ' .. desc
						end

						vim.keymap.set('n', keys, func, { buffer = args.buf, desc = desc })
					end

					nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
					nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

					nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
					nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
					nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
					nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
					nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols,
						'[D]ocument [S]ymbols')
					nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
						'[W]orkspace [S]ymbols')

					-- See `:help K` for why this keymap
					nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
					nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

					-- Lesser used LSP functionality
					nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
					nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
					nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder,
						'[W]orkspace [R]emove Folder')
					nmap('<leader>wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, '[W]orkspace [L]ist Folders')

					-- Create a command `:Format` local to the LSP buffer
					vim.api.nvim_buf_create_user_command(args.buf, 'Format', function(_)
						vim.lsp.buf.format()
					end, { desc = 'Format current buffer with LSP' })

					vim.api.nvim_create_autocmd({ "BufWritePre" }, {
						pattern = { "*.cpp", "*.h", "*.mojo", "*.py", "*.lua", },
						callback = function()
							if client.supports_method("textDocument/formatting") then
								vim.lsp.buf.format()
							end
						end,
					})

					if vim.env.MODULAR_PATH then
						local modular_path = os.getenv("MODULAR_PATH")
						local api_generated_pkgs = vim.fn.expand(
							"$MODULAR_PATH/bazel-bin/SDK/lib/API/python")
						local api_source_pkgs = vim.fn.expand("$MODULAR_PATH/SDK/lib/API/python")
						local pipelines_source_pkgs = vim.fn.expand(
							"$MODULAR_PATH/SDK/public/max-repo/pipelines/python")
						local python_exe = vim.fn.expand("$MODULAR_DERIVED_PATH/autovenv/bin/python")
						local ruff_exe =
						"/home/ubuntu/.local/share/nvim/mason/packages/python-lsp-server/venv/bin/ruff"

						lspconfig.pylsp.setup {
							on_attach = on_attach,
							settings = {
								pylsp = {
									plugins = {
										ruff = {
											enabled = true, -- Enable the plugin
											formatEnabled = true, -- Enable formatting using ruffs formatter
											executable = ruff_exe, -- Custom path to ruff
											-- config = "<path_to_custom_ruff_toml>",  -- Custom config for ruff to use
											extendSelect = { "I" }, -- Rules that are additionally used by ruff
											-- extendIgnore = { "C90" },  -- Rules that are additionally ignored by ruff
											format = { "I" }, -- Rules that are marked as fixable by ruff that should be fixed when running textDocument/formatting
											-- severities = { ["D212"] = "I" },  -- Optional table of rules where a custom severity is desired
											unsafeFixes = true, -- Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action
											-- Rules that are ignored when a pyproject.toml or ruff.toml is present:
											lineLength = 80, -- Line length to pass to ruff checking and formatting
											-- exclude = { "__about__.py" },  -- Files to be excluded by ruff checking
											select = { "ALL" }, -- Rules to be enabled by ruff
											-- Rules to be ignored by ruff:
											-- D401: imperative docstring.
											-- D410: blank line after Returns: in docstring.
											-- COM812: trailing comma missing.
											-- TD003: missing issue link on the line following this TODO.
											ignore = { "D401", "D413", "COM812", "TD003" },
											perFileIgnores = { ["__init__.py"] = "F401" }, -- Rules that should be ignored for specific files
											preview = true,                     -- Whether to enable the preview style linting and formatting.
											targetVersion = "py39",             -- The minimum python version to target (applies for both linting and formatting).
										},
										jedi = {
											environment = python_exe,
											extra_paths = {
												api_generated_pkgs,
												api_source_pkgs,
												pipelines_source_pkgs,
											},
										},
										-- Type checking.
										pylsp_mypy = {
											enabled = true,
											-- overrides = {
											--     "--python-executable", python_exe,
											--     "--show-column-numbers",
											--     "--show-error-codes",
											--     "--no-pretty",
											--     true,
											-- },
											-- report_progress = true,
											-- live_mode = true,
											config = modular_path .. "/mypy.ini",
										},
										pylint = {
											enabled = false -- Disable pylint to avoid conflicts
											-- enabled = true,
											-- executable = "/home/ubuntu/work/modular/.derived/autovenv/bin/pylint",
										},
										-- import sorting
										isort = { enabled = true },
									},
								},
							},
							flags = {
								debounce_text_changes = 200,
							},
							before_init = function(_, config)
								local path_to_append = vim.fn.expand(
									"$MODULAR_PATH/bazel-bin/SDK/lib/API/python:$MODULAR_PATH/SDK/lib/API/python:$MODULAR_PATH/SDK/public/max-repo/pipelines/python")
								config.env = config.env or {}
								config.env.PYTHONPATH = ((config.env.PYTHONPATH and (config.env.PYTHONPATH .. ":")) or "") ..
										path_to_append
								config.env.MYPYPATH = ((config.env.MYPYPATH and (config.env.MYPYPATH .. ":")) or "") ..
										path_to_append
							end
						}

						require("lspconfig.configs").modular = {
							default_config = {
								cmd = { 'modular-lsp-server' },
								filetypes = { 'mlir' },
								root_dir = lspconfig.util.root_pattern('.git'),
							},
						}
						require("lspconfig.configs").mojo = {
							default_config = {
								cmd = { 'mojo-lsp-server' },
								filetypes = { 'mojo' },
								root_dir = lspconfig.util.root_pattern('.git'),
							},
						}
						require("lspconfig.configs").tablegen = {
							default_config = {
								cmd = { 'tblgen-lsp-server', '--tablegen-compilation-database=' .. vim.env.MODULAR_PATH .. '/.derived/build/tablegen_compile_commands.yml' },
								filetypes = { 'tablegen' },
								root_dir = lspconfig.util.root_pattern('.git'),
							},
						}
						local capabilities = vim.lsp.protocol.make_client_capabilities()
						lspconfig.modular.setup({
							capabilities = capabilities,
							on_attach =
									on_attach
						})
						lspconfig.mojo.setup({ capabilities = capabilities, on_attach = on_attach })
						lspconfig.tablegen.setup({
							capabilities = capabilities,
							on_attach =
									on_attach
						})
					end
				end,
			})
		end
	},
}
