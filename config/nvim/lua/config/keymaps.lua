-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Copy file paths to system clipboard
vim.keymap.set("n", "<leader>cp", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify('Copied: "' .. path .. '"')
end, { desc = "Copy relative path" })

vim.keymap.set("n", "<leader>cP", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify('Copied: "' .. path .. '"')
end, { desc = "Copy absolute path" })

vim.keymap.set("n", "<leader>cf", function()
  local filename = vim.fn.expand("%:t")
  vim.fn.setreg("+", filename)
  vim.notify('Copied: "' .. filename .. '"')
end, { desc = "Copy filename" })
