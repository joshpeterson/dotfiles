return {
	-- Nvimtree (File Explorer)
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup {
				update_focused_file = {
					enable = true,
				},
				view = {
					width = 50,
				},
			}
		end,
		keys = {
			{ "<leader>t", "<cmd>NvimTreeToggle<cr>", desc = "NvimTreeToggle" }
		}
	},
}
