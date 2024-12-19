local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap --
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

-- Setup --
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "nvim-lua/plenary.nvim",
  "tpope/vim-fugitive",
  { 'echasnovski/mini.nvim', branch = 'main' },
  { "m4xshen/hardtime.nvim", dependencies = { "MunifTanjim/nui.nvim" }, opts = { enabled = false } },

  -- Colors
  "projekt0n/github-nvim-theme",
  "nvim-treesitter/nvim-treesitter",
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" },

  -- Complete
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  "hrsh7th/cmp-nvim-lsp",

  -- LSP
  "neovim/nvim-lspconfig",
})
