return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Increase the path length shown in statusline
      -- Default is 3, increase to show more path segments before truncating
      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({
          length = 10, -- Show up to 6 path segments (adjust as needed)
        }),
      }
    end,
  },
}
