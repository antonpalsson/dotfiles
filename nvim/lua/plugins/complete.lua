local luasnip = require("luasnip")
luasnip.filetype_extend("ruby", { "rails" })
require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered({ border = "single" }),
    documentation = cmp.config.window.bordered({ border = "single" }),
  },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<C-a>"] = cmp.mapping.abort(),
    ['<C-c>'] = cmp.mapping.complete(),
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = "insert" })
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = "insert" })
      else
        fallback()
      end
    end,
    ["<C-n>"] = function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end,
    ["<C-p>"] = function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp", keyword_length = 2 },
    { name = "luasnip",  keyword_length = 2 },
    { name = "path",     keyword_length = 2 },
    { name = "buffer",   keyword_length = 2 },
  }),
})
