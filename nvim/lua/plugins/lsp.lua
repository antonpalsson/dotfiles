-- LSP & lint & format

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
local null_ls = require("null-ls")

mason.setup()
mason_lspconfig.setup({
	ensure_installed = { "lua_ls", "ruby_lsp", "solargraph", "tailwindcss", "rnix", "ts_ls", "rust_analyzer" },
})

-- LSP
-- lspconfig.ruby_lsp.setup()
lspconfig.solargraph.setup({})
lspconfig.tailwindcss.setup({})
lspconfig.rnix.setup({})
lspconfig.ts_ls.setup({})
lspconfig.rust_analyzer.setup({})

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

-- Lint & format
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier,
		-- null_ls.builtins.formatting.rubocop,
		-- null_ls.builtins.diagnostics.rubocop,
	},
})
