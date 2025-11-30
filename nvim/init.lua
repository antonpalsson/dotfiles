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
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path })
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })
MiniDeps.add({ source = "vague2k/vague.nvim" })
MiniDeps.add({ source = "nvim-treesitter/nvim-treesitter" })
MiniDeps.add({ source = 'neovim/nvim-lspconfig' })
MiniDeps.add({ source = "echasnovski/mini.nvim" })
MiniDeps.add({ source = "folke/snacks.nvim" })
MiniDeps.add({ source = "Saghen/blink.cmp" })
MiniDeps.add({ source = "tpope/vim-fugitive" })
MiniDeps.add({ source = "github/copilot.vim" })
MiniDeps.add({
  source = "jedrzejboczar/devcontainers.nvim",
  depends = { 'miversen33/netman.nvim' }
})


-- My modules --
require("tabline").setup({})
require("menu").setup({})
require("session").setup({})

-- Plugins --
require("plugin")
require("lsp")


-- LSP bindings --
vim.keymap.set("n", "grr", ':Pick lsp scope="references"<CR>', {})
vim.keymap.set("n", "grd", ":Pick lsp scope='declaration'<CR>", {})
vim.keymap.set("n", "gri", ':Pick lsp scope="implementation"<CR>', {})
vim.keymap.set("n", "grt", ':Pick lsp scope="type_declaration"<CR>', {})
vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, {})

vim.keymap.set("n", "tgd", function()
  vim.cmd("tab split"); vim.lsp.buf.definition()
end, {})

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, on_jump = function() vim.diagnostic.open_float() end })
end, {})
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, on_jump = function() vim.diagnostic.open_float() end })
end, {})

vim.keymap.set({ "n", "x" }, "gq", function() vim.lsp.buf.format({ async = true }) end, {})

vim.keymap.set("n", "<leader>ld", function()
  local current_virtual_lines = vim.diagnostic.config().virtual_lines

  vim.diagnostic.config({
    virtual_lines = not current_virtual_lines
  })
end, { silent = true })

vim.diagnostic.config({ virtual_lines = false, underline = true })


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
-- vim.keymap.set("n", "<leader>ft", function() Snacks.explorer() end, {})
