return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          -- Explicitly set filetypes to ensure clangd starts for C++ files
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
          -- Ensure clangd starts in any directory with a .git folder or C++ files
          root_dir = function(fname)
            local util = require("lspconfig.util")
            -- First try the default root patterns
            local root = util.root_pattern(
              "compile_commands.json",
              "compile_flags.txt",
              ".clangd",
              ".clang-tidy",
              ".clang-format",
              "Makefile",
              "CMakeLists.txt",
              "meson.build"
            )(fname)

            -- If no root pattern found, use git root
            if not root then
              root = util.root_pattern(".git")(fname)
            end

            -- If still no root, use the directory of the current file
            if not root then
              root = vim.fn.fnamemodify(fname, ":p:h")
            end

            return root
          end,
        },
      },
    },
  },
}
