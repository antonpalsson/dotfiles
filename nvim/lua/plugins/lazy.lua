-- Lazy

-- Bootstrap
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

-- Plugins
require("lazy").setup({
	-- Colors
	"projekt0n/github-nvim-theme",
	"nvim-treesitter/nvim-treesitter",
	"lewis6991/gitsigns.nvim",
	"nvim-lualine/lualine.nvim",
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl" },

	-- Telescope
	-- "nvim-telescope/telescope.nvim",

	-- Complete & snippets
	-- "hrsh7th/nvim-cmp",
	-- "hrsh7th/cmp-buffer",
	-- "hrsh7th/cmp-path",
	-- "L3MON4D3/LuaSnip",
	-- "saadparwaiz1/cmp_luasnip",
	-- "rafamadriz/friendly-snippets",
	-- "hrsh7th/cmp-nvim-lsp",

	-- LSP & lint & format
	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"nvimtools/none-ls.nvim",

	-- Tpope
	-- "tpope/vim-commentary",
	"tpope/vim-fugitive",

	-- Mini
	{ 'echasnovski/mini.nvim', version = false },

	-- Utils
	"nvim-lua/plenary.nvim",
	-- "nvim-tree/nvim-web-devicons",
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  },
})
