-- Theme --
require("github-theme").setup({
  specs = {
    github_dark_high_contrast = {
      -- bg0 = "#212327",
      bg1 = "#04080D"
    }
  }
})

vim.cmd.colorscheme('github_dark_high_contrast')

-- Treesitter --
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = false },
  incremental_selection = { enable = false },
  textobjects = { enable = false },
})

-- Icons --
require("mini.icons").setup()

-- Indent blankline --
require("ibl").setup({
  scope = { enabled = false },
})

-- Diff --
require("mini.diff").setup({
  view = {
    style = 'sign',
    signs = { add = '+', change = '~', delete = '-' },
    priority = 9,
  }
})

-- Tabline --
vim.api.nvim_set_hl(0, 'TabLine', { fg = 'gray' })
vim.api.nvim_set_hl(0, 'TabLineSel', { fg = 'black', bg = '#71b7ff' })
vim.api.nvim_set_hl(0, 'TabLineFill', { bg = '#04080D' })

-- Statusline --
local mini_statusline = require('mini.statusline')

local function statusline()
  local mode, mode_hl = mini_statusline.section_mode({ trunc_width = 120 })
  local git           = mini_statusline.section_git({ trunc_width = 40 })
  local diff          = mini_statusline.section_diff({ trunc_width = 75 })
  local diagnostics   = mini_statusline.section_diagnostics({ trunc_width = 75 })
  local lsp           = mini_statusline.section_lsp({ icon = 'λ', trunc_width = 75 })
  local filename      = mini_statusline.section_filename({ trunc_width = 9999 }) -- Always truncate
  local percent       = '%2p%%'
  local location      = '%3l:%-2c'

  return mini_statusline.combine_groups({
    { hl = mode_hl,                 strings = { mode } },
    { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
    '%<', -- Mark general truncate point
    { hl = 'MiniStatuslineFilename', strings = { filename } },
    '%=', -- End left alignment
    { hl = 'MiniStatuslineFilename', strings = { '%{&filetype}' } },
    { hl = 'MiniStatuslineFileinfo', strings = { percent } },
    { hl = mode_hl,                  strings = { location } },
  })
end

mini_statusline.setup({
  content = {
    active = statusline
  },
})

-- Starter --
local mini_starter = require("mini.starter")

local function header()
  return [[
   //
 _oo\
(__/ \  _  _
   \  \/ \/ \
   (         )\
    \_______/  \
     [[] [[]
     [[] [[]
  ]]
end

local function footer()
  local version_info = vim.version()
  return string.format("NVIM v%d.%d.%d", version_info.major, version_info.minor, version_info.patch)
end

mini_starter.setup({
  header = header,
  items = {
    { action = ":Explore", name = "Explore", section = "" },
    { action = ":q",       name = "Quit",    section = "" },
  },
  footer = footer,
})
