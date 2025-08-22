-- Configure blink.cmp to not show autocomplete automatically
return {
  {
    "saghen/blink.cmp",
    opts = {
      -- Disable automatic popup
      completion = {
        trigger = {
          -- Don't show completion automatically while typing
          show_on_keyword = false,
          -- Don't show after accepting a completion
          show_on_accept_on_trigger_character = false,
          -- Don't show when entering insert mode
          show_on_insert_on_trigger_character = false,
        },
        list = {
          -- Auto-select first item when popup opens
          selection = { preselect = true },
        },
      },
      -- Configure keymaps for manual trigger
      keymap = {
        preset = "default",
        -- Use Ctrl+Space to manually trigger completion
        ["<C-space>"] = { "show", "fallback" },
        -- Accept completion with Tab or Enter
        ["<Tab>"] = { "accept", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
    },
  },
}
