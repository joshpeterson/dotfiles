return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  keys = {
    { "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
    { "<leader>df", "<cmd>DiffviewFileHistory<cr>", desc = "File History Diff" },
  },
}