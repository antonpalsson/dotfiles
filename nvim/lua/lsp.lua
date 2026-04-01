local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.lsp.config('*', {
  capabilities = capabilities,
  root_markers = { '.git' },
})

vim.lsp.config('ts_ls', {
  root_markers = { 'tsconfig.json', 'package.json' },
})

vim.lsp.config('eslint', {
  root_markers = {
    'eslint.config.js', 'eslint.config.mjs', 'eslint.config.cjs',
    '.eslintrc', '.eslintrc.js', '.eslintrc.json',
    '.eslintrc.yml', '.eslintrc.yaml',
  },
})

vim.lsp.config('tailwindcss', {})

vim.lsp.config('biome', {
  root_markers = { 'biome.json', 'biome.jsonc' },
})

vim.lsp.config('ltex', {
  settings = {
    ltex = { language = "en-GB" },
  },
})

vim.lsp.config('ruby_lsp', {
  root_markers = { 'Gemfile' },
  init_options = {
    addonSettings = {
      ["Ruby LSP Rails"] = { enablePendingMigrationsPrompt = false }
    }
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim', 'require' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

vim.diagnostic.config({
  virtual_lines = false,
  underline = true,
  signs = { priority = 10 }
})

-- LSP toggle picker
local servers = {
  { text = "Typescript LS", name = 'ts_ls',       enabled = vim.lsp.is_enabled('ts_ls') },
  { text = "Eslint",        name = "eslint",      enabled = vim.lsp.is_enabled('eslint') },
  { text = "Biome",         name = "biome",       enabled = vim.lsp.is_enabled('biome') },
  { text = "Tailwind LS",   name = "tailwindcss", enabled = vim.lsp.is_enabled('tailwindcss') },
  { text = "Ruby LSP",      name = 'ruby_lsp',    enabled = vim.lsp.is_enabled('ruby_lsp') },
  { text = "Lua LS",        name = "lua_ls",      enabled = vim.lsp.is_enabled('lua_ls') },
  { text = "Ltex",          name = 'ltex',        enabled = vim.lsp.is_enabled('ltex') }
}

local function lsp_toggle_menu()
  Snacks.picker.pick({
    source = "LSP",
    items = servers,
    layout = { preset = "select" },
    format = function(item)
      local state_display = item.enabled and "● " or "○ "
      return { { state_display .. item.text } }
    end,
    confirm = function(picker, item)
      local new_state = not item.enabled
      vim.lsp.enable(item.name, new_state)
      item.enabled = new_state
      picker.list:update({ force = true })
    end,
  })
end

vim.api.nvim_create_user_command("LspToggle", lsp_toggle_menu, { desc = "LSP Toggle" })
vim.api.nvim_create_user_command("LspLog", function() vim.cmd("tabnew " .. vim.lsp.log.get_filename()) end, {})
vim.api.nvim_create_user_command("LspInfo", function() vim.cmd("checkhealth vim.lsp") end, {})
