-- Hard time --
require("hardtime").setup()
vim.keymap.set("n", "<leader>tht", ":Hardtime toggle<CR>", {}) -- Toggle hardtime

-- Gen --
local gen = require('gen')

gen.setup({
  model = "deepseek-coder-v2",
  init = nil,
  display_mode = "split",
  show_prompt = "full",
  no_auto_close = true,
})

gen.prompts = {
  plain = { prompt = "$input" },
  context = { prompt = "```$filetype\n$text\n```\n\n$input" },
}

vim.keymap.set('n', '<leader>gen', ':Gen plain<CR>')
vim.keymap.set('v', '<leader>gen', ':Gen context<CR>')

-- Copilot --
vim.keymap.set('i', '<C-y>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
vim.keymap.set('i', '<C-u>', '<Plug>(copilot-accept-word)')

vim.g.copilot_no_tab_map = true
