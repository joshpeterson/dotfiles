 return {
   {
     "neovim/nvim-lspconfig",
     opts = {
       servers = {
         solargraph = {},
         tailwindcss = {},
         ruby_lsp = {
           filetypes = { "ruby" },
         },
       },
     },
   },
   {
     "mason-org/mason.nvim",
     opts = function(_, opts)
       vim.list_extend(opts.ensure_installed, {
         "solargraph",
         "tailwindcss-language-server",
       })
     end,
   },
 }
