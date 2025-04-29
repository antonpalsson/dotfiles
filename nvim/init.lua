require("core")

-- Minimal mode --
if vim.env.NVIM_MINIMAL then
  print("Minimal config loaded")
  return
end

-- Bootstrap lazy --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if vim.env.NVIM_INIT then
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
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      { "neovim/nvim-lspconfig" },
    },
    config = function()
      require("lsp")
    end
  },
  { import = "plugins" },
})
