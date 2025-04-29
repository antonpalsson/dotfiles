-- Core --
require("core")

-- Minimal mode --
if vim.env.NVIM_MINIMAL then
  print("Minimal config loaded")
  return
end

-- Deps --
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

-- Plugins --
require("plugins")

-- Pick bindings --
vim.keymap.set("n", "<leader>fe", ":Pick explorer<CR>", {})
vim.keymap.set("n", "<leader>ff", ":Pick files<CR>", {})
vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>", {})
vim.keymap.set("n", "<leader>fb", ":Pick buffers<CR>", {})
vim.keymap.set("n", "<leader>fh", ":Pick git_hunks<CR>", {})
vim.keymap.set("n", "<leader>fc", ":Pick git_commits<CR>", {})
vim.keymap.set("n", "<leader>fd", ":Pick diagnostic<CR>", {})
vim.keymap.set("n", "<leader>f:", ":Pick commands<CR>", {})
vim.keymap.set("n", "<leader>fm", ":Pick marks<CR>", {})
vim.keymap.set("n", "<leader>fo", ":Pick oldfiles<CR>", {})

-- LSP bindings --
vim.keymap.set("n", "grr", ':Pick lsp scope="references"<CR>', {})
vim.keymap.set("n", "grd", ":Pick lsp scope='declaration'<CR>", {})
vim.keymap.set("n", "gri", ':Pick lsp scope="implementation"<CR>', {})
vim.keymap.set("n", "grt", ':Pick lsp scope="type_declaration"<CR>', {})

vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, {})
vim.keymap.set("n", "grn", function() vim.lsp.buf.rename() end, {})
vim.keymap.set("n", "gra", function() vim.lsp.buf.code_action() end, {})
vim.keymap.set("n", "gO",  function() vim.lsp.buf.document_symbol() end, {})
vim.keymap.set({ "n", "x" }, "gq", function() vim.lsp.buf.format({ async = true }) end, {})

vim.keymap.set({ "i", "s" }, "<C-s>", function() vim.lsp.buf.signature_help() end, {})
vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, {})

vim.keymap.set("n", "]g", function() vim.diagnostic.jump({ count = 1 }) end, {})
vim.keymap.set("n", "[g", function() vim.diagnostic.jump({ count = -1 }) end, {})

vim.diagnostic.config({ virtual_lines = false, underline = false })
vim.keymap.set("n", "<leader>lf", function() vim.diagnostic.open_float() end, {})
vim.keymap.set("n", "<leader>ld", function()
  local current_virtual_lines = vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = not current_virtual_lines})
end, { silent = true })

-- Other bindings --
vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit() end, {})
vim.keymap.set("n", "<leader>nto", ":NeovimTips<CR>", {})
vim.keymap.set("n", "<leader>wk", ":WhichKey<CR>", {})
