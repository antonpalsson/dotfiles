-- Bindings
vim.keymap.set('n', '<leader>te', ':Ex<CR>')         -- Explore
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>')     -- New tab
vim.keymap.set('n', '<leader>tN', ':0tabnew<CR>')    -- New tab to the far left
vim.keymap.set('n', '<leader>tl', ':tabmove +1<CR>') -- Move tab to the right
vim.keymap.set('n', '<leader>th', ':tabmove -1<CR>') -- Move tab to the left
vim.keymap.set('n', '<leader>td', ':tab split<CR>')  -- Duplicate tab
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>')   -- Close tab
vim.keymap.set('n', '<leader>tq', ':quit<CR>')       -- Quit
vim.keymap.set('n', '<leader>bd', ':%bd<CR>')        -- Clear all buffers

vim.keymap.set('n', '<TAB>', ':tabnext<CR>')         -- Tabs
vim.keymap.set('n', '<S-TAB>', ':tabprevious<CR>')

vim.keymap.set('v', '<C-S-j>', ":move '>+1<CR>gv=gv") -- Move selecion up/down
vim.keymap.set('v', '<C-S-k>', ":move '<-2<CR>gv=gv")
vim.keymap.set('v', '>', '>gv')                       -- Indention
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '<C-c>', '"+y')                   -- Yank to clipboard

vim.keymap.set('i', '<C-w>', '<Up>')                  -- Mini jumps :)
vim.keymap.set('i', '<C-a>', '<Left>')
vim.keymap.set('i', '<C-s>', '<Down>')
vim.keymap.set('i', '<C-d>', '<Right>')

-- vim.keymap.set('i', '[[', '[]<Left>') -- Pairs
-- vim.keymap.set('i', '{{', '{}<Left>')
-- vim.keymap.set('i', '((', '()<Left>')
-- vim.keymap.set('i', "''", "''<Left>")
-- vim.keymap.set('i', '""', '""<Left>')
-- vim.keymap.set('i', '<<', '<><Left>')
-- vim.keymap.set('i', '||', '||<Left>')
