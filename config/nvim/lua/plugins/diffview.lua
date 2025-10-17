return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  keys = {
    { "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
    { "<leader>df", "<cmd>DiffviewFileHistory<cr>", desc = "File History Diff" },
    { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
  },
  opts = {
    view = {
      merge_tool = {
        layout = "diff4_mixed",
        disable_diagnostics = true,
        winbar_info = true,
      },
    },
  },
}