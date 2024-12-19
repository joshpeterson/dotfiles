return {
	{
		-- Buffer deletion without closing splits
		'ojroques/nvim-bufdel',
		config = function()
			vim.keymap.set('n', '<leader>bd', require('bufdel').delete_buffer_expr,
				{ desc = '[B]uffer [D]elete' })
		end,
	},
}
