return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layout = {
          -- Use a vertical layout with preview below
          preset = "vertical",
        },
        sources = {
          explorer = {
            hidden = true, -- Show hidden files by default
          },
          files = {
            hidden = true, -- Show hidden files in file picker
          },
        },
      },
      scope = { enabled = false }, -- Disable scope to avoid conflicts with diffview
      indent = { enabled = false }, -- Disable indent guides to avoid window conflicts
    },
  },
}
