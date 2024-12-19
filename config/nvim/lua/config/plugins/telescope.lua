return {
	-- Fuzzy Finder (files, lsp, etc)
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				-- This will not install any breaking changes.
				-- For major updates, this must be adjusted manually.
				version = "^1.0.0",
			},
		},
		config = function()
			require("telescope").load_extension("live_grep_args")
			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			local lga_actions = require("telescope-live-grep-args.actions")
			require('telescope').setup {
				defaults = {
					layout_strategy = 'vertical',
					mappings = {
						i = {
							['<C-u>'] = false,
							['<C-d>'] = false,
						},
					},
				},
				extensions = {
					live_grep_args = {
						auto_quoting = true, -- enable/disable auto-quoting
						mappings = { -- extend mappings
							i = {
								["<C-k>"] = lga_actions.quote_prompt(),
								["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							},
						},
					}
				}
			}

			-- Enable telescope fzf native, if installed
			pcall(require('telescope').load_extension, 'fzf')
			pcall(require("telescope").load_extension, 'live_grep_args')

			-- See `:help telescope.builtin`
			vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,
				{ desc = '[?] Find recently opened files' })
			vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,
				{ desc = '[ ] Find existing buffers' })
			vim.keymap.set('n', '<leader>/', function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes')
				.get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end, { desc = '[/] Fuzzily search in current buffer' })

			vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files,
				{ desc = 'Find [G]it [F]iles' })
			vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files,
				{ desc = '[F]ind [F]iles' })
			vim.keymap.set('n', '<leader>sf', require('telescope').extensions.live_grep_args.live_grep_args,
				{ desc = '[S]earch [F]iles' })
			vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume,
				{ noremap = true, silent = true, desc = "[S]earch [R]esume", })
			vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags,
				{ desc = '[S]earch [H]elp' })
			vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string,
				{ desc = '[S]earch current [W]ord' })
			vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep,
				{ desc = '[S]earch by [G]rep' })
			vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics,
				{ desc = '[S]earch [D]iagnostics' })
			vim.keymap.set('n', '<leader>ch', require('telescope.builtin').command_history,
				{ desc = '[C]ommand [H]istory' })
			vim.keymap.set('n', '<leader>fh', require('telescope.builtin').search_history,
				{ desc = '[F]ind [H]istory' })
			vim.keymap.set('n', '<leader>ts', require('telescope.builtin').treesitter,
				{ desc = '[T]ree[S]itter' })
			vim.keymap.set('n', '<leader>qf', require('telescope.builtin').quickfix,
				{ desc = '[Q]uick[F]ix' })
			vim.keymap.set('n', '<leader>qfh', require('telescope.builtin').quickfixhistory,
				{ desc = '[Q]uick[F]ix [H]istory' })
		end
	},
	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
	},
}
