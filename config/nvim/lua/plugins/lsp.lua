-- LSP configuration for multiple languages
-- This configuration ensures LSP servers start properly
-- Supports: C/C++ (clangd), Python (pyright), and Mojo (mojo-lsp-server)
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      -- Setup mason first
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "ruff" }, -- Switched from pyright to ruff
      })

      -- Setup lspconfig
      local lspconfig = require("lspconfig")

      -- Configure clangd for C/C++
      lspconfig.clangd.setup({
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders=true",
          "--fallback-style=llvm",
          "--compile-commands-dir=" .. vim.env.HOME .. "/code/modular",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cc", "cxx", "h", "hpp", "cuda", "proto" },
        root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".clangd", ".git"),
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      })

      -- Configure ruff for Python (much faster than pyright)
      lspconfig.ruff.setup({
        filetypes = { "python" },
        root_dir = lspconfig.util.root_pattern(
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          "Pipfile",
          ".git"
        ),
        init_options = {
          settings = {
            -- Ruff configuration
            lineLength = 88,
            lint = {
              enable = true,
            },
            format = {
              enable = true,
            },
          },
        },
      })

      -- Configure Mojo LSP
      lspconfig.mojo.setup({
        filetypes = { "mojo" },
        single_file_support = true,
      })

      -- Ensure .mojo files are recognized
      vim.filetype.add({
        extension = {
          mojo = "mojo",
        },
      })
    end,
  },
}
