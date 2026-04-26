require("options")
require("bindings")

if vim.env.MINIMAL_NVIM then
  return
end

vim.pack.add({
  "https://github.com/vague2k/vague.nvim",
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/saghen/blink.lib",
  "https://github.com/saghen/blink.cmp",
  'https://github.com/neovim/nvim-lspconfig',
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/meanderingprogrammer/render-markdown.nvim",
  "https://github.com/sindrets/diffview.nvim"
})

require("plugins")
require("lsp")
require("commands")
