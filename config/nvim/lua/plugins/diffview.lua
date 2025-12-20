return {
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>dv", function() vim.cmd("DiffviewOpen") end, desc = "Open Diffview" },
      { "<leader>dc", function() vim.cmd("DiffviewClose") end, desc = "Close Diffview" },
    },
  },
}
