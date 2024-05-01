-- CMP
local cmp = require('cmp')
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load() -- friendly snippets

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-e>'] = cmp.mapping.abort(),

    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = 'insert' })
      else
        fallback()
      end
    end,

    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = 'insert' })
      else
        fallback()
      end
    end,

    ['<C-f>'] = function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end,

    ['<C-b>'] = function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp", keyword_length = 2 },
    { name = "luasnip",  keyword_length = 3 },
    { name = "path",     keyword_length = 3 },
    { name = "buffer",   keyword_length = 4 },
  }),
})


-- LSP
local servers = { 'ruby_lsp', 'rubocop', 'tailwindcss', 'lua_ls', 'rnix', 'tsserver', 'rust_analyzer', 'eslint' }

require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = servers })

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

-- Toggle diagnostic virtual text
vim.diagnostic.config({ virtual_text = false, underline = false })
vim.keymap.set('n', '<leader>dd',
  ':lua vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })<CR>', { silent = true })
-- Format
vim.keymap.set('n', '<leader>df', vim.lsp.buf.format, {})
-- Go to definition
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
