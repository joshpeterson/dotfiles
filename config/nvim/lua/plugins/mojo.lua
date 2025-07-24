return {
  -- Add Mojo filetype detection
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.filetype.add({ extension = { mojo = "mojo" } })
    end,
  },

  -- Configure Mojo LSP
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Configure the custom mojo LSP server
      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")

      if not configs.mojo then
        configs.mojo = {
          default_config = {
            cmd = { "mojo-lsp-server" },
            filetypes = { "mojo" },
            root_dir = lspconfig.util.root_pattern(".git", ".mojo", "pyproject.toml", "setup.py"),
            name = "mojo",
            autostart = true,
          },
        }
      end

      -- Add mojo to the servers list with autostart enabled
      opts.servers = opts.servers or {}
      opts.servers.mojo = {
        autostart = true,
      }
      return opts
    end,
  },

  -- Format on save for Mojo files
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        mojo = { "mojo" },
      },
      formatters = {
        mojo = {
          command = "mojo",
          args = { "format", "-" },
          stdin = true,
        },
      },
    },
  },
}
