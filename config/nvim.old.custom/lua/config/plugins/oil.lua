return {
	{
		'stevearc/oil.nvim',
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		config = function()
			require("oil").setup({
				vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
			})
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
}
