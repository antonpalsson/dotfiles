-- Blink --
require("blink.cmp").setup({
  fuzzy = { implementation = "lua" },
  signature = { enabled = true },
  snippets = { preset = 'mini_snippets' },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
    menu = {
      auto_show = true,
      draw = {
        columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
      },
    },
  },
  keymap = {
    preset = "default",
    ['<Tab>'] = { 'snippet_forward', 'select_and_accept', 'fallback' },
    ['<C-a>'] = { 'show', 'show_documentation', 'hide_documentation' },
  }
})


-- Snacks --
require("snacks").setup({
  bigfile = { enabled = true },
  indent = {
    enabled = true,
    animate = { enabled = false },
  },
  terminal = { enabled = true, },
  picker = { enabled = true, },
  input = { enabled = true, },
})


-- Mini --
require("mini.extra").setup({})
require("mini.icons").setup({})
require("mini.splitjoin").setup({})
require("mini.surround").setup({})
require("mini.ai").setup({})
require("mini.pairs").setup({})
require("mini.git").setup({})

-- Snippets
local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup({
  snippets = {
    gen_loader.from_file('~/.config/nvim/snippets/global.json'),
    gen_loader.from_file('~/.config/nvim/snippets/javascript.json', {
      filetypes = { 'typescript', 'typescriptreact', 'javascriptreact' }
    }),
    gen_loader.from_lang(),
  },
})

-- Pick
require("mini.pick").setup({
  options = {
    content_from_bottom = true,
  },
  window = {
    prompt_prefix = " ",
    config = function()
      return {
        anchor = "SW",
        height = math.min(vim.o.lines, 70),
        width = vim.o.columns,
        row = vim.o.lines - 1,
        col = 0,
      }
    end,
  },
})

-- Diff
require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "+", change = "~", delete = "-" },
    priority = 9,
  }
})

-- Notify
local notify = require("mini.notify")
notify.setup({
  winblend = 100,
  window = {
    max_width_share = 0.5,
    config = function()
      return {
        anchor = "SE",
        row = vim.o.lines - 2,
      }
    end,
  },
})

vim.notify = notify.make_notify({})

-- Statusline
local mini_statusline = require("mini.statusline")
local function statusline()
  local mode, mode_hl = mini_statusline.section_mode({ trunc_width = 120 })
  local git           = mini_statusline.section_git({ trunc_width = 40 })
  local diff          = mini_statusline.section_diff({ trunc_width = 75, icon = "" })
  local diagnostics   = mini_statusline.section_diagnostics({ trunc_width = 75 })
  local lsp           = mini_statusline.section_lsp({ icon = "λ", trunc_width = 75 })
  local filename      = mini_statusline.section_filename({ trunc_width = 9999 }) -- Always truncate
  local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })
  local percent       = "%2p%%"
  local location      = "%3l:%-2c"

  return mini_statusline.combine_groups({
    { hl = mode_hl,                 strings = { mode } },
    { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
    "%<", -- Mark general truncate point
    { hl = "MiniStatuslineFilename", strings = { filename } },
    { hl = "MiniStatuslineDivide" },
    "%=", -- End left alignment
    { hl = "MiniStatuslineFiletype", strings = { "%{&filetype}", lsp } },
    { hl = "MiniStatuslineSearch",   strings = { percent, search } },
    { hl = mode_hl,                  strings = { location } },
  })
end

mini_statusline.setup({
  content = {
    active = statusline
  },
})

-- Starter
local mini_starter = require("mini.starter")
mini_starter.setup({
  query_updaters = 'elbq',
  header = function()
    return ""
  end,
  items = {
    { action = ":enew | Ex",    name = "Explore",      section = "" },
    { action = ":Session load", name = "Load session", section = "" },
    { action = ":enew",         name = "Buffer",       section = "" },
    { action = ":q",            name = "Quit",         section = "" },
  },
  footer = function()
    local version_info = vim.version()
    return string.format("nvim v%d.%d.%d", version_info.major, version_info.minor, version_info.patch)
  end
})


-- Theme --
require("vague").setup({
  transparent = true,
  italic = false,
})

vim.cmd.colorscheme("vague")

local theme_colors = require("vague.config.internal").current.colors
local colors = {
  black = '#000000',
  gray1 = '#1e1e1e',
  gray2 = '#323232',
  gray3 = '#464646',
  gray4 = '#5a5a5a',
  white = '#ffffff',
  fg = theme_colors.fg,
}

vim.api.nvim_set_hl(0, "TabLineFill", { fg = colors.fg, bg = colors.black })
vim.api.nvim_set_hl(0, "TabLineSel", { fg = colors.white, bg = colors.gray4 })
vim.api.nvim_set_hl(0, "TabLine", { fg = colors.gray4, bg = colors.black })

vim.api.nvim_set_hl(0, "SnacksIndent", { fg = colors.gray1 })
vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = colors.gray1 })

vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = colors.fg, bg = colors.gray3 })
vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = colors.fg, bg = colors.gray2 })
vim.api.nvim_set_hl(0, "MiniStatuslineDivide", { fg = colors.fg, bg = colors.black })
vim.api.nvim_set_hl(0, "MiniStatuslineFiletype", { fg = colors.fg, bg = colors.gray2 })
vim.api.nvim_set_hl(0, "MiniStatuslineSearch", { fg = colors.fg, bg = colors.gray3 })


-- Treesitter --
require("nvim-treesitter.configs").setup({
  ensure_installed = { "ruby" },
  auto_install = false,
  sync_install = false,
  ignore_install = { "" },
  modules = {},
  highlight = { enable = true, additional_vim_regex_highlighting = { 'ruby' }, },
  indent = { enable = true, disable = { 'ruby' } },
})
