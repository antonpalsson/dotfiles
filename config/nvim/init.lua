if not vim.env.MINIMAL_NVIM then
  local path_package = vim.fn.stdpath('data') .. '/site/'
  local mini_path = path_package .. 'pack/deps/start/mini.nvim'

  if not vim.loop.fs_stat(mini_path) then
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path })
    vim.cmd('packadd mini.nvim | helptags ALL')
  end

  require('mini.deps').setup({ path = { package = path_package } })

  MiniDeps.add({ source = "vague2k/vague.nvim" })
  MiniDeps.add({ source = "echasnovski/mini.nvim" })
  MiniDeps.add({ source = "folke/snacks.nvim" })
  MiniDeps.add({ source = "Saghen/blink.cmp" })
  MiniDeps.add({ source = 'neovim/nvim-lspconfig' })
  MiniDeps.add({ source = "nvim-treesitter/nvim-treesitter" })
  MiniDeps.add({ source = "MeanderingProgrammer/render-markdown.nvim" })
  MiniDeps.add({ source = "sindrets/diffview.nvim" })
end

require("core")
require("bindings")
require("commands")
require("lsp")
