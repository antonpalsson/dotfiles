local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path })
  vim.cmd('packadd mini.nvim | helptags ALL')
end

require('mini.deps').setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  add({ source = "vague2k/vague.nvim" })
  add({ source = "echasnovski/mini.nvim" })
  add({ source = "nvim-treesitter/nvim-treesitter"})
  add({ source = "github/copilot.vim" })
end)

later(function()
  add({ source = "folke/snacks.nvim" })
  add({ source = "Saghen/blink.cmp" })
  add({ source = 'neovim/nvim-lspconfig' })
  add({ source = "sindrets/diffview.nvim" })
  add({ source = "mikavilpas/yazi.nvim", depends = { 'nvim-lua/plenary.nvim' } })
end)

require("core")
require("lsp")
require("bindings")
