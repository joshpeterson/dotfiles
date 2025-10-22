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
        ensure_installed = { "clangd", "pyright" },
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

      -- Configure pyright for Python
      lspconfig.pyright.setup({
        filetypes = { "python" },
        root_dir = lspconfig.util.root_pattern(
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          "Pipfile",
          "pyrightconfig.json",
          ".git"
        ),
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic",
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
