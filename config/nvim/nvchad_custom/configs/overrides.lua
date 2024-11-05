local M = {}

M.treesitter = {
	ensure_installed = {
		"vim",
		"lua",
		"c",
		"cpp",
		"python",
		"markdown",
		"markdown_inline",
		"tablegen",
	},
	indent = {
		enable = true,
		-- disable = {
		--   "python"
		-- },
	},
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- c/cpp stuff
		"clangd",
		"clang-format",
		"codelldb",
	},
}

-- git support in nvimtree
M.nvimtree = {
	git = {
		enable = true,
	},

	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
}

M.telescope = {
	opts = {
		extension_list = { "fzf" },
	},
}

return M
