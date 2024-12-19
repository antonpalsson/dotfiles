local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.ruby_lsp.setup({
  cmd = { "mise", "x", "--", "ruby-lsp" },
  capabilities = capabilities,
})

lspconfig.tailwindcss.setup({
  cmd = { "mise", "x", "--", "tailwindcss-language-server", "--stdio" },
  capabilities = capabilities,
})

lspconfig.ts_ls.setup({
  cmd = { "mise", "x", "--", "typescript-language-server", "--stdio" },
  capabilities = capabilities,
})

lspconfig.lua_ls.setup({
  cmd = { "mise", "x", "--", "lua-language-server" },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { "vim" } },
    },
  },
  capabilities = capabilities,
})

-- After Neovim v0.11
-- vim.lsp.config('*', {
--   capabilities = capabilities,
--   root_markers = { '.git' },
-- })

-- vim.lsp.config('ruby_lsp', {
--   cmd = { "mise", "x", "--", "ruby-lsp" },
--   filetypes = { "ruby", "eruby" },
--   init_options = { formatter = "auto" },
-- })

-- vim.lsp.enable('ruby_lsp')
