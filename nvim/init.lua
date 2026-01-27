local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path })
  vim.cmd('packadd mini.nvim | helptags ALL')
end

require('mini.deps').setup({ path = { package = path_package } })
local add, now = MiniDeps.add, MiniDeps.now

now(function()
  add({ source = "vague2k/vague.nvim" })
  add({ source = "echasnovski/mini.nvim" })
  add({ source = "folke/snacks.nvim" })
  add({ source = "Saghen/blink.cmp" })
  add({ source = 'neovim/nvim-lspconfig' })
  -- add({ source = "github/copilot.vim" })
  add({ source = "nvim-treesitter/nvim-treesitter" })
  add({ source = "MeanderingProgrammer/render-markdown.nvim" })
  add({ source = "sindrets/diffview.nvim" })
end)

require("core")
require("bindings")
require("commands")
require("lsp")
