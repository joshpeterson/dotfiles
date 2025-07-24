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
      -- Add mojo to the servers list
      opts.servers = opts.servers or {}
      opts.servers.mojo = {}
      return opts
    end,
    config = function(_, opts)
      -- Configure the custom mojo LSP server
      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")

      if not configs.mojo then
        configs.mojo = {
          default_config = {
            cmd = { "mojo-lsp-server" },
            filetypes = { "mojo" },
            root_dir = lspconfig.util.root_pattern(".git", ".mojo"),
            name = "mojo",
          },
        }
      end

      -- Let LazyVim handle the server setup
      require("lazyvim.util").lsp.on_attach(function(client, buffer)
        -- Additional mojo-specific setup if needed
      end, "mojo")
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
