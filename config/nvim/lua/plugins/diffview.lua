return {
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>dv", function() vim.cmd("DiffviewOpen") end, desc = "Open Diffview" },
      { "<leader>dc", function() vim.cmd("DiffviewClose") end, desc = "Close Diffview" },
      { "<leader>dm", function() vim.cmd("DiffviewOpen main") end, desc = "Open Diffview vs main" },
    },
  },
}
