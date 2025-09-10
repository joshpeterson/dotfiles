return {
  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        lsp = {
          win = {
            type = "split", -- split window
            relative = "win", -- relative to current window
            -- position = "bottom", -- bottom
            size = 0.4, -- 40% of the window
          },
        },
        symbols = { -- Configure symbols mode
          win = {
            type = "split", -- split window
            relative = "win", -- relative to current window
            -- position = "bottom", -- bottom
            size = 0.4, -- 40% of the window
          },
        },
      },
    },
  },
}
