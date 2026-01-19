-- Options
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.netrw_banner = 0

vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.termguicolors = true
vim.opt.shortmess:append("I")

vim.o.mouse = "a"
vim.o.mousescroll = "ver:2,hor:0"
vim.o.undofile = true
vim.o.swapfile = false
vim.o.wrap = false
vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.list = true
vim.o.showmode = false
vim.o.shiftwidth = 2
vim.o.showtabline = 2
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.winborder = "single"
vim.o.cursorline = false
vim.o.scrolloff = 10
vim.o.inccommand = "split"
vim.o.confirm = true

-- Initial plugins
MiniDeps.now(function()
  -- Tabline
  require("tabline").setup({})

  -- Theme
  require("vague").setup({
    transparent = true,
    italic = false
  })

  vim.cmd.colorscheme("vague")

  -- Custom highlighting
  local theme_fg = require("vague.config.internal").current.colors.fg
  local colors = {
    black = '#000000',
    gray1 = '#1e1e1e',
    gray2 = '#323232',
    gray3 = '#464646',
    gray4 = '#5a5a5a',
    white = '#ffffff',
    fg = theme_fg,
  }

  vim.api.nvim_set_hl(0, "TabLineFill", { fg = colors.fg, bg = colors.black })
  vim.api.nvim_set_hl(0, "TabLineSel", { fg = colors.white, bg = colors.gray4 })
  vim.api.nvim_set_hl(0, "TabLine", { fg = colors.gray4, bg = colors.black })
  vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = colors.fg, bg = colors.gray3 })
  vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = colors.fg, bg = colors.gray2 })
  vim.api.nvim_set_hl(0, "MiniStatuslineDivide", { fg = colors.fg, bg = colors.black })
  vim.api.nvim_set_hl(0, "MiniStatuslineFiletype", { fg = colors.fg, bg = colors.gray2 })
  vim.api.nvim_set_hl(0, "MiniStatuslineSearch", { fg = colors.fg, bg = colors.gray3 })
  vim.api.nvim_set_hl(0, "SnacksIndent", { fg = colors.gray1 })
  vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = colors.gray1 })

  -- Statusline
  local mini_statusline = require("mini.statusline")
  mini_statusline.setup({
    content = {
      active = function()
        local mode, mode_hl = mini_statusline.section_mode({ trunc_width = 120 })
        local git           = mini_statusline.section_git({ trunc_width = 40 })
        local diff          = mini_statusline.section_diff({ trunc_width = 75, icon = "" })
        local diagnostics   = mini_statusline.section_diagnostics({ trunc_width = 75 })
        local lsp           = mini_statusline.section_lsp({ icon = "λ", trunc_width = 75 })
        local filename      = mini_statusline.section_filename({ trunc_width = 9999 }) -- Always truncate
        local search        = mini_statusline.section_searchcount({ trunc_width = 75 })
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
    },
  })

  -- Markdown
  require('render-markdown').setup({
    heading = {
      sign = false,
      position = 'inline',
      backgrounds = {},
    },
  })

  -- Snacks
  require("snacks").setup({
    bigfile = { enabled = true },
    input = { enabled = true },
    indent = {
      enabled = true,
      animate = { enabled = false }
    },
    picker = {
      enabled = true,
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        explorer = { hidden = true },
      },
      explorer = {
        trash = true,
      }
    },
    image = {
      enabled = true,
      doc = {
        inline = false,
      }
    },
  })

  -- Treesitter
  local ensure_installed = { "lua", "ruby", "markdown" }
  require("nvim-treesitter").install(ensure_installed)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = ensure_installed,
    callback = function()
      pcall(vim.treesitter.start)
    end,
  })
end)

-- Plugins
MiniDeps.later(function()
  -- Session
  require("session").setup({})

  -- Mini
  require("mini.extra").setup({})
  require("mini.icons").setup({})
  require("mini.splitjoin").setup({})
  require("mini.pairs").setup({})
  require("mini.surround").setup({})

  -- Blink
  require("blink.cmp").setup({
    fuzzy = { implementation = "lua" },
    signature = { enabled = true },
    sources = { default = { 'lsp', 'path', 'buffer' } },
    keymap = {
      preset = "default",
      ['<Tab>'] = { 'select_and_accept', 'fallback' },
      ['<C-a>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-c>'] = { 'hide', 'fallback' },
    },
    completion = {
      trigger = {
        show_on_insert_on_trigger_character = false,
        show_on_keyword = false,
      }
    }
  })

  -- Mini diff
  require("mini.diff").setup({
    view = {
      style = "sign",
      signs = { add = "+", change = "~", delete = "-" },
      priority = 9
    }
  })

  -- Auto resize splits
  vim.api.nvim_create_autocmd("VimResized", {
    command = "wincmd =",
  })
end)
