-- Helper --
local function setup(label, name, lspconfig, opts)
  opts = opts or {}

  local default_config = dofile(
    vim.fn.stdpath('data') ..
    '/site/pack/deps/opt/nvim-lspconfig/lsp/' ..
    lspconfig ..
    '.lua'
  )

  local config = vim.tbl_deep_extend('force', default_config, opts)
  vim.lsp.config(name, config)

  return { label = label, name = name, config = config }
end


-- Ruby --
local ruby_lsp_default = setup('Ruby LSP', 'ruby_lsp_default', 'ruby_lsp', {
  init_options = {
    addonSettings = {
      ["Ruby LSP Rails"] = { enablePendingMigrationsPrompt = false, },
    },
  },
})

local ruby_lsp_lspdock = setup('Ruby LSP (lspdock)', 'ruby_lsp_lspdock', 'ruby_lsp', {
  cmd = { 'lspdock', '--exec', 'ruby-lsp' },
  init_options = {
    addonSettings = {
      ["Ruby LSP Rails"] = { enablePendingMigrationsPrompt = false, },
    },
  },
})


-- Web --
local ts_ls_default = setup('Typescript LS', 'ts_ls_default', 'ts_ls')
local tl_ls_default = setup('Tailwind LS', 'tl_ls_default', 'tailwindcss')
local eslint_default = setup('Eslint', 'eslint_default', 'eslint')

local ts_ls_node_modules = setup('Typescript LS (node modules)', 'ts_ls_node_modules', 'ts_ls', {
  cmd = { 'node_modules/.bin/typescript-language-server', '--stdio' },
})

local tl_ls_node_modules = setup('Tailwind LS (node modules)', 'tl_ls_node_modules', 'tailwindcss', {
  cmd = { 'node_modules/.bin/tailwindcss-language-server', '--stdio' },
})

local eslint_node_modules = setup('Eslint (node modules)', 'eslint_node_modules', 'eslint', {
  cmd = { 'node_modules/.bin/vscode-eslint-language-server', '--stdio' },
})


-- Lua --
local lua_ls_default = setup('Lua LS', 'lua_ls_default', 'lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = {
        globals = { 'vim', 'require' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})


-- LSP menu --
Menu.create({
  name = "LspToggle",
  title = "Toggle LSP servers",
  togglable = true,
  auto_close = false,
  items = {
    { label = ts_ls_default.label,       name = ts_ls_default.name, },
    { label = eslint_default.label,      name = eslint_default.name, },
    { label = tl_ls_default.label,       name = tl_ls_default.name, },
    { label = lua_ls_default.label,      name = lua_ls_default.name, },
    { label = ruby_lsp_default.label,    name = ruby_lsp_default.name, },
    { label = ts_ls_node_modules.label,  name = ts_ls_node_modules.name, },
    { label = eslint_node_modules.label, name = eslint_node_modules.name, },
    { label = tl_ls_node_modules.label,  name = tl_ls_node_modules.name, },
    { label = ruby_lsp_lspdock.label,    name = ruby_lsp_lspdock.name, },
  },
  callback = function(item)
    vim.lsp.enable(item.name, item.enable)
    vim.notify(item.name .. ": " .. tostring(item.enable))
  end
})
