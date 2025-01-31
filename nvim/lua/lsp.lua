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

-- Bindings
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts)
    vim.keymap.set("n", "grr", ":Pick lsp scope='references'<CR>", opts)
    vim.keymap.set("n", "grd", ":Pick lsp scope='declaration'<CR>", opts)

    vim.keymap.set({ 'n', 'x' }, 'gq', ':lua vim.lsp.buf.format({async = true})<CR>', opts)
    vim.keymap.set('n', 'grn', ':lua vim.lsp.buf.rename()<CR>', opts)
    vim.keymap.set('n', 'gra', ':lua vim.lsp.buf.code_action()<CR>', opts)

    vim.keymap.set("n", "gri", ":Pick lsp scope='implementation'<CR>", opts)
    vim.keymap.set("n", "grt", ":Pick lsp scope='type_declaration'<CR>", opts)

    vim.keymap.set('n', 'gO', ':lua vim.lsp.buf.document_symbol()<CR>', opts)
    vim.keymap.set({ 'i', 's' }, '<C-s>', ':lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.keymap.set('n', 'K', ':lua vim.lsp.buf.hover()<CR>', opts)
  end,
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
