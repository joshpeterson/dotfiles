return {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    -- Enable Copilot for all file types
    vim.g.copilot_filetypes = {
      ["*"] = true,
    }

    -- Key mappings for Copilot
    vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
      desc = "Accept Copilot suggestion",
    })

    vim.keymap.set("i", "<C-l>", "<Plug>(copilot-accept-word)", {
      desc = "Accept next word from Copilot",
    })

    vim.keymap.set("i", "<C-]>", "<Plug>(copilot-next)", {
      desc = "Next Copilot suggestion",
    })

    vim.keymap.set("i", "<C-[>", "<Plug>(copilot-previous)", {
      desc = "Previous Copilot suggestion",
    })

    -- Disable default tab mapping to avoid conflicts
    vim.g.copilot_no_tab_map = true
  end,
}