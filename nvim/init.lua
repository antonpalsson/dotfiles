-- Lazy nvim (bootstrap)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
end
vim.opt.rtp:prepend(lazypath)

-- Lazy nvim (plugins)
require('lazy').setup({
  'projekt0n/github-nvim-theme', -- Github theme
  'nvim-lua/plenary.nvim',  -- Neovim utils (required by Telescope)
  'nvim-tree/nvim-web-devicons',  -- Icons (required by Lualine)
  'nvim-treesitter/nvim-treesitter',  -- Treesitter
  'nvim-lualine/lualine.nvim',  -- Status/tab line
  'nvim-telescope/telescope.nvim',  -- Telescope
  'nvim-telescope/telescope-live-grep-args.nvim',  -- Telescope live grep args (extension to Telescope)
  'tpope/vim-commentary',  -- Smart comments

  -- LSP, autocomplete, snippets
  {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
  'neovim/nvim-lspconfig',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-buffer',
  'L3MON4D3/LuaSnip',
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
})


-- LSP
vim.diagnostic.config({ virtual_text = false, underline = false })

local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    lsp_zero.default_setup,
  },
})

require('cmp').setup({
  sources = {
    -- {name = 'nvim_lsp'},
    {name = 'buffer', keyword_length = 3},
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})


-- Options
vim.g.mapleader = ' '
-- vim.o.fileencoding = 'utf-8'
vim.o.termguicolors = true
-- vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.errorbells = false
vim.o.swapfile = false
vim.o.undofile = false
vim.o.number = true
vim.o.relativenumber = false
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
vim.o.scrolloff = 10
vim.o.signcolumn = 'yes'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.updatetime = 50


-- Bindings
vim.keymap.set('n', '<leader>te', ':Ex<CR>') -- Explore
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>') -- New tab
vim.keymap.set('n', '<leader>tN', ':0tabnew<CR>') -- New tab to the far left
vim.keymap.set('n', '<leader>tl', ':tabmove +1<CR>') -- Move tab to the right
vim.keymap.set('n', '<leader>th', ':tabmove -1<CR>') -- Move tab to the left
vim.keymap.set('n', '<leader>td', ':tab split<CR>') -- Duplicate tab
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>') -- Close tab
vim.keymap.set('n', '<leader>tq', ':quit<CR>') -- Quit
vim.keymap.set('n', '<leader>bd', ':%bd<CR>') -- Clear all buffers

vim.keymap.set('n', '<TAB>', ':tabnext<CR>') -- Tabs
vim.keymap.set('n', '<S-TAB>', ':tabprevious<CR>')

vim.keymap.set('v', '<C-S-j>', ":move '>+1<CR>gv=gv") -- Move selecion up/down
vim.keymap.set('v', '<C-S-k>', ":move '<-2<CR>gv=gv")
vim.keymap.set('v', '>', '>gv') -- Indention
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '<C-c>', '"+y') -- Yank to clipboard

vim.keymap.set('i', '[[', '[]<Left>') -- Pairs
vim.keymap.set('i', '{{', '{}<Left>')
vim.keymap.set('i', '((', '()<Left>')
vim.keymap.set('i', "''", "''<Left>")
vim.keymap.set('i', '""', '""<Left>')
-- vim.keymap.set('i', '<<', '<><Left>')
vim.keymap.set('i', '||', '||<Left>')

vim.keymap.set('i', '<C-w>', '<Up>') -- Mini jumps
vim.keymap.set('i', '<C-a>', '<Left>')
vim.keymap.set('i', '<C-s>', '<Down>')
vim.keymap.set('i', '<C-d>', '<Right>')

-- Toggle diagnostic virtual text
vim.keymap.set('n', '<leader>dd', ':lua vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })<CR>', {silent = true})
vim.keymap.set('n', '<leader>df', vim.lsp.buf.format, {}) -- Format
vim.keymap.set('n', '<leader>dg', ':! rubocop -A %<CR>') -- Rubo unsafe format


-- Themes
require('github-theme').setup({})
vim.cmd('colorscheme github_dark_high_contrast')
vim.cmd('highlight Normal guibg=NONE ctermbg=NONE') -- Remove background color


-- Treesitter
require('nvim-treesitter.configs').setup({
  highlight = {enable = true},
  indent = {enable = true},
})


-- Telescope
local telescope = require('telescope')
telescope.load_extension("live_grep_args")

local telescopeConfig = require("telescope.config")
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) } -- Clone the default Telescope configuration
table.insert(vimgrep_arguments, "--hidden") -- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--glob") -- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup {
  defaults = {
		vimgrep_arguments = vimgrep_arguments,
    layout_config = {width = 0.999}
	},
	pickers = {
		find_files = {
			find_command = {"rg", "--files", "--hidden", "--glob", "!**/.git/*"},
		},
	},
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fq', builtin.quickfix, {})


-- Lualine
require('lualine').setup({
  options = {
    section_separators = {left = ' ', right = ' '},
    component_separators = {left = ' ', right = ' '}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {{'branch', color = {fg = 'white'}}},
    lualine_c = {{'filename', path = 1, symbols = {modified = ' [modified] ', readonly = ' [read only] ', unnamed = ''}}, 'diff', 'diagnostics'},
    lualine_x = {'encoding', 'fileformat'},
    lualine_y = {{'progress', color = {fg = 'white' }}},
    lualine_z = {'location'}
  },
  tabline = {
    lualine_a = {{'tabs', mode = 2, max_length = vim.o.columns, separator = {left = '', right = ''}}}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {{'filename', symbols = {modified = ' [modified] ', readonly = ' [read only] ', unnamed = ''}}},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
})

