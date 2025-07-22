return {
	'diegoulloao/nvim-file-location',
	{
		'Almo7aya/openingh.nvim',
		keys = {
			{ "<leader>gh", "<cmd>OpenInGHFile<cr>", desc = "Open current file on Github" }
		}

	},
	config = function()
		-- For plugin to copy current file path to clipboard
		-- require plugin
		-- Configuration for plugin to copy file path to clipboard
		require("nvim-file-location").setup({
			keymap = "<leader>L",
			mode = "workdir", -- options: workdir | absolute
			add_line = true,
			add_column = false,
			default_register = "*",
		})
	end
}
