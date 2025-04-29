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

local add = MiniDeps.add
add({ source = "https://github.com/vague2k/vague.nvim" })
add({ source = "https://github.com/nvim-treesitter/nvim-treesitter" })
add({ source = 'https://github.com/neovim/nvim-lspconfig' })
add({ source = "https://github.com/echasnovski/mini.nvim" })
add({ source = "https://github.com/folke/snacks.nvim" })
add({ source = "https://github.com/tpope/vim-fugitive" })
add({ source = "https://github.com/Saghen/blink.cmp" })
add({ source = "https://github.com/L3MON4D3/LuaSnip" })
add({ source = "https://github.com/robitx/gp.nvim" })


-- Plugins --
require("plugins")
require("langs")


-- LSP bindings --
vim.keymap.set("n", "grr", ':Pick lsp scope="references"<CR>', {})
vim.keymap.set("n", "grd", ":Pick lsp scope='declaration'<CR>", {})
vim.keymap.set("n", "gri", ':Pick lsp scope="implementation"<CR>', {})
vim.keymap.set("n", "grt", ':Pick lsp scope="type_declaration"<CR>', {})
vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, {})
vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, {})
vim.keymap.set({ "n", "x" }, "gq", function() vim.lsp.buf.format({ async = true }) end, {})

vim.diagnostic.config({ virtual_lines = false, underline = false })
vim.keymap.set("n", "<leader>lf", function() vim.diagnostic.open_float() end, {})
vim.keymap.set("n", "<leader>ld", function()
  local current_virtual_lines = vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = not current_virtual_lines })
end, { silent = true })

local lsps = {
  { label = "Lua LS",            name = "lua_ls",           enable = false },
  { label = "Typescript LS",     name = "ts_ls",            enable = false },
  { label = "Eslint",            name = "eslint",           enable = false },
  { label = "Tailwind LS",       name = "tailwindcss",      enable = false },
  { label = "Ruby LS",           name = "ruby_lsp",         enable = false },
  { label = "Ruby LS (lspdock)", name = "lspdock_ruby_lsp", enable = false },
}

local menus = require("menu")
menus.create_menu('lspt', true, lsps, function(item)
  vim.lsp.enable(item.name, item.enable)
  vim.notify(item.name .. ": " .. tostring(item.enable))
end, { title = "Toggle LSP servers", desc = "Toggle LSP servers" })


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
vim.keymap.set("n", "<leader>fs", function() Snacks.explorer()end, {})


-- Git bindings --
vim.keymap.set("n", "<leader>lgg", function() Snacks.lazygit() end, {})
vim.keymap.set("n", "<leader>lgd", ":Gvdiffsplit<CR>", {})
vim.keymap.set("n", "<leader>lgs", ":Gvsplit<CR>", {})
vim.keymap.set("n", "<leader>lgb", ":Git blame<CR>", {})
