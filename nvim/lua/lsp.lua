require('devcontainers').setup({})

-- Ruby
vim.lsp.config('ruby_lsp', {
  -- cmd = require('devcontainers').lsp_cmd(vim.lsp.config.ruby_lsp.cmd),
  init_options = {
    addonSettings = {
      ["Ruby LSP Rails"] = { enablePendingMigrationsPrompt = false, },
    },
  },
})

-- Web
vim.lsp.config('ts_ls', {
  -- cmd = require('devcontainers').lsp_cmd(vim.lsp.config.ts_ls.cmd),
  -- cmd = { 'yarn', 'typescript-language-server', '--stdio' }
})

vim.lsp.config('eslint', {
  -- cmd = require('devcontainers').lsp_cmd(vim.lsp.config.eslint.cmd),
  -- cmd = { 'yarn', 'vscode-eslint-language-server', '--stdio' }
})

vim.lsp.config('tailwindcss', {
  -- cmd = require('devcontainers').lsp_cmd(vim.lsp.config.tailwindcss.cmd),
  -- cmd = { 'yarn', 'tailwindcss-language-server', '--stdio' }
})

-- Lua --
vim.lsp.config('lua_ls', {
  -- cmd = require('devcontainers').lsp_cmd(vim.lsp.config.lua_ls.cmd),
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

-- Copilot bindings --
vim.g.copilot_enabled = 0
vim.keymap.set('i', '<C-g>w', '<Plug>(copilot-accept-word)')
vim.keymap.set('i', '<C-g>l', '<Plug>(copilot-accept-line)')
vim.keymap.set('i', '<C-g>x', '<Plug>(copilot-dismiss)')


-- LSP menu --
Menu.create({
  name = "LspToggle",
  title = "Toggle LSP servers",
  togglable = true,
  auto_close = false,
  items = {
    { label = "Typescript ls", name = 'ts_ls' },
    { label = "Eslint",        name = 'eslint' },
    { label = "Tailwind ls",   name = 'tailwindcss' },
    { label = "Ruby lsp",      name = 'ruby_lsp' },
    { label = "Lua ls",        name = 'lua_ls' },
    {
      label = 'Copilot',
      name = 'copilot',
      callback = function(item)
        if item.enable then
          vim.g.copilot_enabled = 1
          vim.notify("Copilot: enabled")
        else
          vim.g.copilot_enabled = 0
          vim.notify("Copilot: disabled")
        end
      end
    },
  },
  callback = function(item)
    vim.lsp.enable(item.name, item.enable)
    vim.notify(item.name .. ": " .. tostring(item.enable))
  end
})
