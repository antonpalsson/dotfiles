-- Helper --
local function setup_lsp(name, label, lspconfig, opts)
  opts = opts or {}

  local default_config = dofile(
    vim.fn.stdpath('data') ..
    '/site/pack/deps/opt/nvim-lspconfig/lsp/' ..
    lspconfig ..
    '.lua'
  )

  local config = vim.tbl_deep_extend('force', default_config, opts)
  vim.lsp.config(name, config)

  return { name = name, label = label, config = config }
end


-- Ruby --
local ruby_lsp_my = setup_lsp('ruby_lsp_my', 'Ruby LSP', 'ruby_lsp', {
  init_options = {
    addonSettings = {
      ["Ruby LSP Rails"] = {
        enablePendingMigrationsPrompt = false,
      },
    },
  },
})

local ruby_lsp_lspdock = setup_lsp('ruby_lsp_lspdock', 'Ruby LSP (lspdock)', 'ruby_lsp', {
  cmd = { 'lspdock', '--exec', 'ruby-lsp' },
  init_options = {
    addonSettings = {
      ["Ruby LSP Rails"] = {
        enablePendingMigrationsPrompt = false,
      },
    },
  },
})


-- Web --
local ts_ls_my = setup_lsp('ts_ls_my', 'Typescript LS', 'ts_ls')
local tl_ls_my = setup_lsp('tl_ls_my', 'Tailwind LS', 'tailwindcss')
local eslint_my = setup_lsp('eslint_my', 'Eslint', 'eslint')

local ts_ls_node_modules = setup_lsp('ts_ls_node_modules', 'Typescript LS (node modules)', 'ts_ls', {
  cmd = { 'node_modules/.bin/typescript-language-server', '--stdio' },
})

local tl_ls_node_modules = setup_lsp('tl_ls_node_modules', 'Tailwind LS (node modules)', 'tailwindcss', {
  cmd = { 'node_modules/.bin/tailwindcss-language-server', '--stdio' },
})

local eslint_node_modules = setup_lsp('eslint_node_modules', 'Eslint (node modules)', 'eslint', {
  cmd = { 'node_modules/.bin/vscode-eslint-language-server', '--stdio' },
})


-- Lua --
local lua_ls_my = setup_lsp('lua_ls_my', 'Lua LS', 'lua_ls', {
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


-- LSP menu --
local menus = require("menu")
menus.create_menu('lspt', {
    { label = ts_ls_my.label,            name = ts_ls_my.name,            enable = false },
    { label = tl_ls_my.label,            name = tl_ls_my.name,            enable = false },
    { label = eslint_my.label,           name = eslint_my.name,           enable = false },
    { label = lua_ls_my.label,           name = lua_ls_my.name,           enable = false },
    { label = ruby_lsp_my.label,         name = ruby_lsp_my.name,         enable = false },
    { label = ts_ls_node_modules.label,  name = ts_ls_node_modules.name,  enable = false },
    { label = tl_ls_node_modules.label,  name = tl_ls_node_modules.name,  enable = false },
    { label = eslint_node_modules.label, name = eslint_node_modules.name, enable = false },
    { label = ruby_lsp_lspdock.label,    name = ruby_lsp_lspdock.name,    enable = false },
  },
  function(item)
    vim.lsp.enable(item.name, item.enable)
    vim.notify(item.name .. ": " .. tostring(item.enable))
  end,
  { title = "Toggle LSP servers", desc = "Toggle LSP servers", togglable = true }
)
