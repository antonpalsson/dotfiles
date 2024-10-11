-- Colors

-- Theme
require("github-theme").setup({
	options = {
		transparent = true,
	},
})

vim.cmd("colorscheme github_dark_high_contrast")

-- Treesitter
require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
	indent = { enable = false },
  incremental_selection = { enable = false },
  textobjects = { enable = false },
})

-- Git signs
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
	},
	signs_staged = {
		add = { text = "+" },
		change = { text = "~" },
	},
})

-- Indent blankline
require("ibl").setup({
	scope = { enabled = false },
})

-- Lualine
require("lualine").setup({
	options = {
		section_separators = { left = " ", right = " " },
		component_separators = { left = " ", right = " " },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { { "branch", color = { fg = "white" } } },
		lualine_c = {
			"diff",
			{ "filename", path = 1, symbols = { modified = " [modified] ", readonly = " [read only] ", unnamed = "" } },
		},
		lualine_x = { "encoding", "fileformat" },
		lualine_y = { { "progress", color = { fg = "white" } } },
		lualine_z = { "location" },
	},
	tabline = {
		lualine_a = { { "tabs", mode = 2, max_length = vim.o.columns, separator = { left = "", right = "" } } },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{ "filename", symbols = { modified = " [modified] ", readonly = " [read only] ", unnamed = "" } },
		},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
})
