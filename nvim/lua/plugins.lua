-- Hardtime --
require("hardtime").setup({
  restricted_keys = {
    ["h"] = false,
    ["j"] = false,
    ["k"] = false,
    ["l"] = false,
  },
  resetting_keys = {
    ["gp"] = false,
    ["gP"] = false,
    ["gq"] = false,
  },
})


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
})


-- Mini --
require("mini.extra").setup({})
require("mini.icons").setup({})
require("mini.splitjoin").setup({})
require("mini.surround").setup({})
require("mini.ai").setup({})
require("mini.pairs").setup({})

-- Snippets
local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup({
  snippets = {
    gen_loader.from_file('~/.config/nvim/snippets/global.json'),
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
  local diff          = mini_statusline.section_diff({ trunc_width = 75 })
  local diagnostics   = mini_statusline.section_diagnostics({ trunc_width = 75 })
  local lsp           = mini_statusline.section_lsp({ icon = "λ", trunc_width = 75 })
  local filename      = mini_statusline.section_filename({ trunc_width = 9999 }) -- Always truncate
  local percent       = "%2p%%"
  local location      = "%3l:%-2c"

  return mini_statusline.combine_groups({
    { hl = mode_hl,                 strings = { mode } },
    { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
    "%<", -- Mark general truncate point
    { hl = "MiniStatuslineFilename", strings = { filename } },
    "%=", -- End left alignment
    { hl = "MiniStatuslineFilename", strings = { "%{&filetype}" } },
    { hl = "MiniStatuslineFileinfo", strings = { percent } },
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
  query_updaters = 'sebq',
  header = function()
    return ""
  end,
  items = {
    { action = ":enew | Ex",  name = "Explore", section = "" },
    { action = ":Pick files", name = "Search",  section = "" },
    { action = ":enew",       name = "Buffer",  section = "" },
    { action = ":q",          name = "Quit",    section = "" },
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

local c = require("vague.config.internal").current.colors
local c_trans = "#04080D"

vim.api.nvim_set_hl(0, "TabLine", { fg = c.fg })
vim.api.nvim_set_hl(0, "TabLineSel", { fg = "white", bg = "#4A4A4A", bold = true })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = c_trans })

vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2A2A2A" })

vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#1A1A1A" })
vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#3A3A3A" })

vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = "white", bg = "#4A4A4A" })
vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = c.bg, bg = c.builtin })
vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = c.bg, bg = c.delta })
vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = c.bg, bg = c.plus })
vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = c.bg, bg = c.hint })
vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", { fg = c.bg, bg = c.hint })
vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = c.fg, bg = "#2A2A2A" })
vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = c.fg, bg = c_trans })
vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = c.fg, bg = "#2A2A2A" })


-- Treesitter --
require("nvim-treesitter.configs").setup({
  ensure_installed = { "ruby" },
  highlight = { enable = true, additional_vim_regex_highlighting = { 'ruby' }, },
  indent = { enable = true, disable = { 'ruby' } },
})
