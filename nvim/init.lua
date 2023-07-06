-- Packer plugs
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer
  use 'nvim-treesitter/nvim-treesitter' -- Treesitter
  --use 'nvim-treesitter/playground' -- Treesitter playgournd
  use 'nvim-lua/plenary.nvim' -- Neovim utils (required by Telescope)
  use 'nvim-telescope/telescope.nvim' -- Telescope
  use 'nvim-tree/nvim-web-devicons' -- Icons (required by Lualine)
  use 'nvim-lualine/lualine.nvim' -- Status/tab line
  --use 'tpope/vim-fugitive' -- Git
  --use 'ThePrimeagen/harpoon' -- Marks

  -- Themes
  use 'Mofiqul/vscode.nvim'
  use 'navarasu/onedark.nvim'
  use { 'rose-pine/neovim', as = 'rose-pine' }

  -- LSP
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim', run = function() pcall(vim.cmd, 'MasonUpdate') end},
      {'williamboman/mason-lspconfig.nvim'},
      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    }
  }
end)


-- Themes
require('rose-pine').setup({
  variant = 'main',
  disable_background = true,
  disable_float_background = true,
})
vim.cmd('colorscheme rose-pine')

--require('onedark').setup {
--  style = 'warmer',
--  transparent = true,
--  lualine = {
--    transparent = true,
--  },
--}
--require('onedark').load()

--require('vscode').setup({ 
--  transparent = true, 
--  italic_comments = true 
--})
--require('vscode').load()


-- Options
vim.g.mapleader = ' '
vim.o.fileencoding = 'utf-8'
vim.o.termguicolors = true
--vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.errorbells = false
vim.o.swapfile = false
vim.o.undofile = false
vim.o.number = true
vim.o.relativenumber = false
vim.o.wrap = true
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.cursorline = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.numberwidth = 4
vim.o.showtabline = 2
vim.o.scrolloff = 10
vim.o.signcolumn = 'yes'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.updatetime = 50


-- Bindings
vim.keymap.set('n', '<leader>te', ':Ex<CR>')
vim.keymap.set('n', '<leader>tn', ':$tabnew<CR>')
vim.keymap.set('n', '<leader>tN', ':0tabnew<CR>')
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>')
vim.keymap.set('n', '<leader>to', ':tabonly<CR>')
vim.keymap.set('n', '<leader>th', ':tabmove -1<CR>')
vim.keymap.set('n', '<leader>tl', ':tabmove +1<CR>')

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv") -- Move selecion up/down
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<leader>y', '"+y') -- Copy to clipboard


-- Treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  highlight = { 
    enable = true 
  },
})

-- Treesitter playground
--require "nvim-treesitter.configs".setup {
--  playground = {
--    enable = true,
--    disable = {},
--    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
--    persist_queries = false, -- Whether the query persists across vim sessions
--    keybindings = {
--      toggle_query_editor = 'o',
--      toggle_hl_groups = 'i',
--      toggle_injected_languages = 't',
--      toggle_anonymous_nodes = 'a',
--      toggle_language_display = 'I',
--      focus_language = 'f',
--      unfocus_language = 'F',
--      update = 'R',
--      goto_node = '<cr>',
--      show_help = '?',
--    },
--  }
--}


-- Telescope
--require('telescope').setup {
--  defaults = { 
--    file_ignore_patterns = { 
--      '.git/*',
--      'vendor/*',
--      'node_modules/*'
--    },
--  },
--  pickers = {
--    find_files = {
--      hidden = true
--    },
--  },
--}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


-- Lualine
require('lualine').setup({
  options = {
    section_separators = { left = ' ', right = ' ' },
    component_separators = { left = ' ', right = ' ' }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      { 'branch', color = { fg = 'white' } },
    },
    lualine_c = {
      {
        'filename',
        path = 1,
        symbols = {
          modified = ' [modified] ',
          readonly = ' [read only] ',
          unnamed = ''
        }
      },
      'diff',
      'diagnostics'
    },
    lualine_x = { 'encoding', 'fileformat' },
    lualine_y = { { 'progress', color = { fg = 'white' } } },
    lualine_z = { 'location' }
  },
  tabline = {
    lualine_a = {
      {
        'tabs',
        mode = 2,
        max_length = vim.o.columns,
        separator = { left = '', right = '' }
      }
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        symbols = {
          modified = ' [modified] ',
          readonly = ' [read only] ',
          unnamed = ''
        }
      }
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
})


-- LSP
vim.diagnostic.config({
  virtual_text = false,
})

local lsp = require('lsp-zero').preset({})
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup()

