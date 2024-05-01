-- Telescope
local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

telescope.setup {
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      height = 0.999,
      width = 0.999,
      preview_height = 0.7
    },
    border = {},
    borderchars = { "─", " ", " ", " ", " ", " ", " ", " " },
    mappings = {
      i = {
        -- open all selected in new tabs
        ["<C-o>"] = function(p_bufnr)
          actions.send_selected_to_qflist(p_bufnr)

          vim.cmd([[
            let qflist = getqflist()
            for i in range(len(qflist))
              execute 'tabedit ' . bufname(qflist[i].bufnr)
            endfor
          ]])
        end
      },
      n = {
        -- history
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
      }
    },
  },
  pickers = {
    find_files = {
      find_command = { 'rg', '--hidden', '--files', '-g', '!.git/**', '-g', '!**/cache/**' },
    },
    live_grep = {
      additional_args = { '--hidden', '-g', '!.git/**' },
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
    }
  },
}

telescope.load_extension('fzf')

-- show line numbers in preview window
vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number"

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fq', builtin.quickfix, {})
vim.keymap.set('n', '<leader>fss', builtin.git_status, {})
