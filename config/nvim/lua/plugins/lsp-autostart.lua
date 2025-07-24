return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      -- Ensure autostart is enabled
      autoformat = true,
      setup = {
        -- Force autostart for specific servers
        clangd = function(_, opts)
          opts.autostart = true
        end,
        pyright = function(_, opts)
          opts.autostart = true
        end,
        mojo = function(_, opts)
          opts.autostart = true
        end,
      },
    },
    config = function(_, opts)
      -- Ensure LSP servers start automatically when opening files
      local lsp_util = require("lazyvim.util.lsp")
      
      -- Create autocmd to start LSP when entering buffers
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "TabEnter" }, {
        callback = function(args)
          local bufnr = args.buf
          local ft = vim.bo[bufnr].filetype
          
          -- Map filetypes to their LSP servers
          local ft_to_lsp = {
            c = "clangd",
            cpp = "clangd",
            cc = "clangd",
            cxx = "clangd",
            h = "clangd",
            hpp = "clangd",
            hh = "clangd",
            hxx = "clangd",
            python = "pyright",
            mojo = "mojo",
          }
          
          local lsp_name = ft_to_lsp[ft]
          if lsp_name then
            -- Check if LSP is already attached
            local clients = vim.lsp.get_clients({ bufnr = bufnr, name = lsp_name })
            if #clients == 0 then
              -- Try to start the LSP
              vim.cmd("LspStart " .. lsp_name)
            end
          end
        end,
      })
      
      -- Apply LazyVim's default config
      require("lazyvim.plugins.lsp.keymaps").on_attach = lsp_util.on_attach
    end,
  },
}