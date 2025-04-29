return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    { "neovim/nvim-lspconfig" },
  },
  config = function()
    require("mason-lspconfig").setup {
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "eslint",
        "tailwindcss",
        "ruby_lsp",
      },
    }

    vim.lsp.config("*", {
      root_markers = { ".git" },
    })

    vim.lsp.config("ruby_lsp", {
      cmd = { "mise", "x", "--", "ruby-lsp" }
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = { library = vim.api.nvim_get_runtime_file("", true) },
          telemetry = { enable = false },
        },
      },
    })
  end
}

-- local function current_repo()
--   local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
--   if not handle then return nil end
--   local result = handle:read("*a")
--   handle:close()
--
--   if result == "" then return nil end
--   return vim.fn.fnamemodify(result:gsub("%s+", ""), ":t")
-- end
