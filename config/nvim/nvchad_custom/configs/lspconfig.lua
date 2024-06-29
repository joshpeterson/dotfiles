local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities
}

if vim.env.MODULAR_PATH then
  require("lspconfig.configs").modular = {
    default_config = {
      cmd = { 'modular-lsp-server' },
      filetypes = { 'mlir' },
      root_dir = lspconfig.util.root_pattern('.git'),
    },
  }
  require("lspconfig.configs").mojo = {
    default_config = {
      cmd = { 'mojo-lsp-server' },
      filetypes = { 'mojo' },
      root_dir = lspconfig.util.root_pattern('.git'),
    },
  }
  require("lspconfig.configs").tablegen = {
    default_config = {
      cmd = { 'tblgen-lsp-server', '--tablegen-compilation-database='..vim.env.MODULAR_PATH..'/.derived/build/tablegen_compile_commands.yml' },
      filetypes = { 'tablegen' },
      root_dir = lspconfig.util.root_pattern('.git'),
    },
  }
  lspconfig.modular.setup( {capabilities = capabilities, on_attach = on_attach})
  lspconfig.mojo.setup(    {capabilities = capabilities, on_attach = on_attach})
  lspconfig.tablegen.setup({capabilities = capabilities, on_attach = on_attach})
end

-- if you just want default config for the servers then put them in a table
local servers = { }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- 
-- lspconfig.pyright.setup { blabla}
