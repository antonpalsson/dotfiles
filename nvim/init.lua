vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

require("options")
require("bindings")
require("tabline").setup({ show_navigation_count = true })
require("session").setup({ auto_load = true })

if vim.env.MINIMAL_NVIM then
  return
end

local gh = function(x) return 'https://github.com/' .. x end
vim.pack.add({
  gh("vague2k/vague.nvim"),
  gh("echasnovski/mini.nvim"),
  gh("folke/snacks.nvim"),
  gh("saghen/blink.lib"),
  gh("saghen/blink.cmp"),
  gh("neovim/nvim-lspconfig"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("meanderingprogrammer/render-markdown.nvim"),
  gh("sindrets/diffview.nvim")
})

require("plugins")
require("lsp")
require("commands")
