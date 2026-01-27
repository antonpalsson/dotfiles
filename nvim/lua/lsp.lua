-- MiniDeps.now(function()
--   -- Copilot
--   vim.g.copilot_enabled = 0
-- end)

MiniDeps.later(function()
  -- Lsps
  local capabilities = require('blink.cmp').get_lsp_capabilities()

  vim.lsp.config('ts_ls', {
    capabilities = capabilities,
    init_options = {
      tsserver = {
        path = vim.fn.getcwd() .. '/node_modules/typescript/lib'
      }
    },
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact"
    },
  })
  vim.lsp.config('eslint', {
    capabilities = capabilities,
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
      "astro",
      "htmlangular"
    }
  })
  vim.lsp.config('tailwindcss', { capabilities = capabilities })
  vim.lsp.config('biome', {
    capabilities = capabilities,
    filetypes = {
      "astro",
      "css",
      "graphql",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "jsonc",
      "svelte",
      "typescript",
      "typescriptreact",
      "vue"
    }
  })

  vim.lsp.config('ltex', {
    settings = {
      ltex = {
        language = "en-GB",
      },
    },
  })

  vim.lsp.config('ruby_lsp', {
    capabilities = capabilities,
    init_options = {
      addonSettings = {
        ["Ruby LSP Rails"] = { enablePendingMigrationsPrompt = false }
      }
    },
  })

  vim.lsp.config('lua_ls', {
    capabilities = capabilities,
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

  -- Diagnostic config
  vim.diagnostic.config({
    virtual_lines = false,
    underline = true,
    signs = { priority = 10 }
  })

  -- Lsp menu
  local servers = {
    { text = "Typescript LS", name = 'ts_ls',       enabled = vim.lsp.is_enabled('ts_ls') },
    { text = "Eslint",        name = "eslint",      enabled = vim.lsp.is_enabled('eslint') },
    { text = "Biome",         name = "biome",       enabled = vim.lsp.is_enabled('biome') },
    { text = "Tailwind LS",   name = "tailwindcss", enabled = vim.lsp.is_enabled('tailwindcss') },
    { text = "Ruby LSP",      name = 'ruby_lsp',    enabled = vim.lsp.is_enabled('ruby_lsp') },
    { text = "Lua LS",        name = "lua_ls",      enabled = vim.lsp.is_enabled('lua_ls') },
    -- { text = "Copilot",       name = 'copilot',     enabled = vim.g.copilot_enabled == 1 },
    { text = "Ltex",          name = 'ltex',        enabled = vim.lsp.is_enabled('ltex') }
  }

  function Lsp_toggle_menu()
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

        -- if item.name == "copilot" then
        --   vim.g.copilot_enabled = new_state and 1 or 0
        -- else
        --   vim.lsp.enable(item.name, new_state)
        -- end

        vim.lsp.enable(item.name, new_state)

        item.enabled = new_state
        picker.list:update({ force = true })
      end,
    })
  end

  -- User commands for lsps
  vim.api.nvim_create_user_command("LspToggle", Lsp_toggle_menu, { desc = "LSP Toggle" })
  vim.api.nvim_create_user_command("LspLog", function() vim.cmd("tabnew " .. vim.lsp.log.get_filename()) end, {})
  vim.api.nvim_create_user_command("LspInfo", function() vim.cmd("checkhealth vim.lsp") end, {})
end)
