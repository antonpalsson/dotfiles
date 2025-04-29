require("mason-lspconfig").setup {
  ensure_installed = {
    "lua_ls",
    "ts_ls",
    "eslint",
    "tailwindcss",
    "ruby_lsp",
  },
  automatic_enable = true,
}

vim.lsp.config("*", {
  root_markers = { '.git' },
})

vim.lsp.config("ruby_lsp", {
  cmd = { "mise", "x", "--", "ruby-lsp" }
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    },
  },
})

vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', {})
vim.keymap.set("n", "grr", ":Pick lsp scope='references'<CR>", {})
vim.keymap.set("n", "grd", ":Pick lsp scope='declaration'<CR>", {})

vim.keymap.set({ 'n', 'x' }, 'gq', ':lua vim.lsp.buf.format({async = true})<CR>', {})
vim.keymap.set('n', 'grn', ':lua vim.lsp.buf.rename()<CR>', {})
vim.keymap.set('n', 'gra', ':lua vim.lsp.buf.code_action()<CR>', {})

vim.keymap.set("n", "gri", ":Pick lsp scope='implementation'<CR>", {})
vim.keymap.set("n", "grt", ":Pick lsp scope='type_declaration'<CR>", {})

vim.keymap.set('n', 'gO', ':lua vim.lsp.buf.document_symbol()<CR>', {})
vim.keymap.set({ 'i', 's' }, '<C-s>', ':lua vim.lsp.buf.signature_help()<CR>', {})
vim.keymap.set('n', 'K', ':lua vim.lsp.buf.hover()<CR>', {})

vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)

-- local function current_repo()
--   local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
--   if not handle then return nil end
--   local result = handle:read("*a")
--   handle:close()
--
--   if result == '' then return nil end
--   return vim.fn.fnamemodify(result:gsub("%s+", ""), ":t")
-- end
