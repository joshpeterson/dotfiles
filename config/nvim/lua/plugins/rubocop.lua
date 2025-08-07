return {
  "nvim-lua/plenary.nvim", -- Required for some async operations
  {
    "nvim-lua/plenary.nvim",
    config = function()
      vim.api.nvim_create_autocmd({"BufWritePost"}, {
        pattern = "*.rb",
        callback = function()
          vim.fn.jobstart("bundle exec rubocop -A", { clear_env = true, detach = true })
        end,
      })
    end,
  },
}