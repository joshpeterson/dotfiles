return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layout = {
          -- Use a vertical layout with preview below
          preset = "vertical",
        },
      },
      scope = { enabled = false }, -- Disable scope to avoid conflicts with diffview
      indent = { enabled = false }, -- Disable indent guides to avoid window conflicts
    },
  },
}
