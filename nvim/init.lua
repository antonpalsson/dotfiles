-- Core --
require("core")

if vim.env.NVIM_MINIMAL then
  return
end

-- Plugins --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "nvim-lua/plenary.nvim",
  "tpope/vim-fugitive",
  { 'echasnovski/mini.nvim',               branch = 'main' },

  -- Colors
  "projekt0n/github-nvim-theme",
  "nvim-treesitter/nvim-treesitter",
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" },

  -- Complete
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",

  -- LSP
  "neovim/nvim-lspconfig",

  -- Playground
  { "m4xshen/hardtime.nvim", dependencies = { "MunifTanjim/nui.nvim" }, opts = { enabled = false } },
  "David-Kunz/gen.nvim",
  "github/copilot.vim"
})

-- Plugin setup --
require("mini.ai").setup()
require("mini.splitjoin").setup()
require("mini.comment").setup({ start_of_line = true })
require("mini.surround").setup()
-- require("mini.pairs").setup()
require("pickers")
require("colors")
require("completion")
require("lsp")
require("playground")
