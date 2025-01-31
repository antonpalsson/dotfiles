-- Hard time --
require("hardtime").setup()
vim.keymap.set("n", "<leader>tht", ":Hardtime toggle<CR>", {}) -- Toggle hardtime

-- Gen --
local gen = require('gen')

gen.setup({
  model = "qwen2.5-coder:14b",
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
vim.keymap.set('n', '<leader>ges', function() require('gen').select_model() end)

-- Copilot --
vim.keymap.set('i', '<C-y>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
vim.keymap.set('i', '<C-u>', '<Plug>(copilot-accept-word)')

vim.g.copilot_no_tab_map = true
