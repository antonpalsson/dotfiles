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
MiniDeps.add({ source = "https://github.com/vague2k/vague.nvim" })
MiniDeps.add({ source = "https://github.com/nvim-treesitter/nvim-treesitter" })
MiniDeps.add({ source = 'https://github.com/neovim/nvim-lspconfig' })
MiniDeps.add({ source = "https://github.com/echasnovski/mini.nvim" })
MiniDeps.add({ source = "https://github.com/folke/snacks.nvim" })
MiniDeps.add({ source = "https://github.com/Saghen/blink.cmp" })
MiniDeps.add({ source = "https://github.com/tpope/vim-fugitive" })
MiniDeps.add({ source = "https://github.com/m4xshen/hardtime.nvim" })
MiniDeps.add({ source = "https://github.com/github/copilot.vim" })


-- Plugins --
require("plugin")
require("lsp")
require("session")


-- LSP bindings --
vim.keymap.set("n", "grr", ':Pick lsp scope="references"<CR>', {})
vim.keymap.set("n", "grd", ":Pick lsp scope='declaration'<CR>", {})
vim.keymap.set("n", "gri", ':Pick lsp scope="implementation"<CR>', {})
vim.keymap.set("n", "grt", ':Pick lsp scope="type_declaration"<CR>', {})
vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, {})
vim.keymap.set("n", "tgd", function()
  vim.cmd("tab split"); vim.lsp.buf.definition()
end, {})
vim.keymap.set({ "n", "x" }, "gq", function() vim.lsp.buf.format({ async = true }) end, {})
vim.keymap.set("n", "<leader>lf", function() vim.diagnostic.open_float() end, {})

vim.keymap.set("n", "<leader>ld", function()
  local current_virtual_lines = vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({
    virtual_lines = not current_virtual_lines
  })
end, { silent = true })

vim.diagnostic.config({ virtual_lines = false, underline = false })


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
vim.keymap.set("n", "<leader>ft", function() Snacks.explorer() end, {})


-- Git bindings --
vim.keymap.set("n", "<leader>lgd", ":Gvdiffsplit<CR>", {})
vim.keymap.set("n", "<leader>lgs", ":Gvsplit<CR>", {})
vim.keymap.set("n", "<leader>lgb", ":Git blame<CR>", {})


-- Hardtime toggle --
local hardtime_enabled = true
vim.keymap.set("n", "<leader>tht", function()
  hardtime_enabled = not hardtime_enabled
  vim.cmd("Hardtime " .. (hardtime_enabled and "enable" or "disable"))
  vim.notify("Hardtime: " .. tostring(hardtime_enabled))
end, {})
