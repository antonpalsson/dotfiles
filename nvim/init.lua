-- Packer plugs
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer
  use 'nvim-lua/plenary.nvim' -- Neovim utils (required by Telescope)
  use 'nvim-tree/nvim-web-devicons' -- Icons (required by Lualine)

  use 'Mofiqul/vscode.nvim' -- VS code theme

  use 'nvim-treesitter/nvim-treesitter' -- Treesitter
  use 'nvim-telescope/telescope.nvim' -- Telescope
  use 'nvim-lualine/lualine.nvim' -- Status/tab line

  -- use {
  --   'VonHeikemen/lsp-zero.nvim',
  --   requires = {
  --     {'neovim/nvim-lspconfig'}, -- LSP Support
  --     {'williamboman/mason.nvim'},
  --     {'williamboman/mason-lspconfig.nvim'},
  --     {'hrsh7th/nvim-cmp'}, -- Autocompletion
  --     {'hrsh7th/cmp-buffer'},
  --     {'hrsh7th/cmp-path'},
  --     {'saadparwaiz1/cmp_luasnip'},
  --     {'hrsh7th/cmp-nvim-lsp'},
  --     {'hrsh7th/cmp-nvim-lua'},
  --     {'L3MON4D3/LuaSnip'}, -- Snippets
  --     {'rafamadriz/friendly-snippets'},
  --   }
  -- }
end)

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
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.cursorline = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.numberwidth = 4
vim.o.showtabline = 2
vim.o.scrolloff = 30
-- vim.o.colorcolumn = '120'
vim.o.signcolumn = 'yes'
vim.o.splitbelow = true
vim.o.splitright = true

-- Bindings
vim.api.nvim_set_keymap('n', '<leader>t', ':Texplore<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>T', ':Texplore | :tabmove -1<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>e', ':Explore<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':quit<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>w', ':write<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>rv', ':vertical res +5<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>rh', ':res +5<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>bc', ':%bd|e#<CR>', { noremap = true })

local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})


-- Theme
vim.o.background = 'dark'
require('vscode').setup({
  transparent = true,
  italic_comments = true,
})

-- Lualine
require('lualine').setup({
  options = {
    section_separators = { left = ' ', right = ' ' },
    component_separators = { left = ' ', right = ' ' }
  },
  sections = {
    lualine_a = {'mode'},
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
    lualine_x = {'encoding', 'fileformat'},
    lualine_y = { { 'progress', color = { fg = 'white' } } },
    lualine_z = {'location'}
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

-- Treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  highlight = { enable = true },
})

