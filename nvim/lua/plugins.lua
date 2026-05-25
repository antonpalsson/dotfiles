-- Mini
require("mini.statusline").setup({})
require("mini.extra").setup({})
require("mini.icons").setup({})
require("mini.splitjoin").setup({})
require("mini.pairs").setup({})
require("mini.surround").setup({})
require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "+", change = "~", delete = "-" },
    priority = 9
  }
})

-- Snacks
require("snacks").setup({
  bigfile  = { enabled = true },
  input    = { enabled = true },
  indent   = { enabled = true, animate = { enabled = false } },
  image    = { enabled = true, doc = { inline = false } },
  notifier = {
    enabled = true,
    top_down = false,
    margin = { top = 0, right = 0, bottom = 1 },
  },
  picker   = {
    enabled = true,
    sources = {
      files    = { hidden = true },
      grep     = { hidden = true },
      explorer = { hidden = true, ignored = true },
    },
    explorer = { trash = true },
  },
})

-- Blink
require("blink.cmp").setup({
  fuzzy = { implementation = "rust" },
  signature = { enabled = true },
  sources = { default = { "lsp", "path", "buffer" } },
  cmdline = { enabled = false },
  keymap = {
    preset = "default",
    ["<Tab>"] = { "select_and_accept", "fallback" },
    ["<C-a>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-c>"] = { "hide", "fallback" },
  },
  completion = {
    trigger = {
      -- Disable all auto-triggers; use C-a to trigger manually
      prefetch_on_insert = false,
      show_in_snippet = false,
      show_on_backspace = false,
      show_on_backspace_in_keyword = false,
      show_on_backspace_after_accept = false,
      show_on_backspace_after_insert_enter = false,
      show_on_keyword = false,
      show_on_trigger_character = false,
      show_on_insert = false,
      show_on_accept_on_trigger_character = false,
      show_on_insert_on_trigger_character = false,
    }
  }
})

-- Diffview
require("diffview").setup({
  enhanced_diff_hl = true,
  use_icons = false,
  show_help_hints = false,
})

-- Treesitter
local ts_langs = { "lua", "ruby", "markdown", "regex" }
require("nvim-treesitter").install(ts_langs)

-- Markdown
require("render-markdown").setup({
  heading = {
    sign = false,
    position = "inline",
    backgrounds = {},
  },
  sign = {
    enabled = false,
  },
  code = {
    disable_background = true,
    border = "thin",
    language_border = "-",
    below = "-",
  },
})

-- Theme
require("vague").setup({
  transparent = true,
  italic = false
})

vim.cmd.colorscheme("vague")

-- Custom highlighting
local theme_fg = require("vague.config.internal").current.colors.fg
local custom_colors = {
  black = "#000000",
  dark = "#161616",
  light = "#636363",
  white = "#ffffff",
  fg = theme_fg,
}

vim.api.nvim_set_hl(0, "TabLineFill", { fg = custom_colors.fg, bg = custom_colors.black })
vim.api.nvim_set_hl(0, "TabLineSel", { fg = custom_colors.white, bg = custom_colors.light })
vim.api.nvim_set_hl(0, "TabLine", { fg = custom_colors.light, bg = custom_colors.dark })
vim.api.nvim_set_hl(0, "SnacksIndent", { fg = custom_colors.dark })
vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = custom_colors.dark })
