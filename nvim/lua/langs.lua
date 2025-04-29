local ls = require("luasnip")
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local function add_snippets(filetypes, snippet)
  for _, filetype in ipairs(filetypes) do
    ls.add_snippets(filetype, snippet)
  end
end


---------
-- All --
---------
add_snippets({ "all" }, {
  s("lorem", {
    t(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
  })
})


----------
-- Ruby --
----------
local ruby_default_config = dofile(vim.fn.stdpath('data') .. '/site/pack/deps/opt/nvim-lspconfig/lsp/ruby_lsp.lua')
vim.lsp.config('lspdock_ruby_lsp', vim.tbl_deep_extend('force', ruby_default_config, {
  cmd = { 'lspdock', '--exec', 'ruby-lsp' },
  init_options = {
    addonSettings = {
      ["Ruby LSP Rails"] = {
        enablePendingMigrationsPrompt = false,
      },
    },
  },
}))

vim.lsp.config('ruby_lsp', {
  init_options = {
    addonSettings = {
      ["Ruby LSP Rails"] = {
        enablePendingMigrationsPrompt = false,
      },
    },
  },
})


---------
-- Web --
---------
add_snippets({ "html", "javascriptreact", "typescriptreact" }, {
  s("tag", fmt(
    [[
    <{}>
      {}
    </{}>
    ]], {
      i(1, "div"), i(3, ""), rep(1)
    })
  )
})

add_snippets({ "html", "javascriptreact", "typescriptreact" }, {
  s("cn", fmt(
    [[
    className='{}'
    ]], {
      i(1, "")
    })
  )
})

add_snippets({ "javascript", "typescript", "javascriptreact", "typescriptreact" }, {
  s("cl", fmt(
    [[
    console.log({})
    ]], {
      i(1)
    })
  )
})


---------
-- Lua --
---------
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim', 'require' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
