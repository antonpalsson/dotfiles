-- Bindings

vim.keymap.set("n", "<leader>te", ":Ex<CR>", {}) -- Explore
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", {}) -- New tab
vim.keymap.set("n", "<leader>tN", ":0tabnew<CR>", {}) -- New tab to the far left
vim.keymap.set("n", "<leader>tl", ":tabmove +1<CR>", {}) -- Move tab to the right
vim.keymap.set("n", "<leader>th", ":tabmove -1<CR>", {}) -- Move tab to the left
vim.keymap.set("n", "<leader>td", ":tab split<CR>", {}) -- Duplicate tab
vim.keymap.set("n", "<leader>bdt", ":bdelete<CR>", {}) -- Delete current buffers
vim.keymap.set("n", "<leader>bda", ":%bdelete<CR>", {}) -- Delete all buffers
vim.keymap.set("n", "<leader>bdl", ":%bdelete<CR>", {}) -- Clear all buffers to the right

vim.keymap.set("n", "<TAB>", ":tabnext<CR>", {}) -- Tabs
vim.keymap.set("n", "<S-TAB>", ":tabprevious<CR>", {})

vim.keymap.set("v", "<C-S-j>", ":move '>+1<CR>gv=gv", {}) -- Move selecion up/down
vim.keymap.set("v", "<C-S-k>", ":move '<-2<CR>gv=gv", {})
vim.keymap.set("v", ">", ">gv", {}) -- Indention
vim.keymap.set("v", "<", "<gv", {})

vim.keymap.set("v", "<C-c>", '"+y', {}) -- Copy to clipboard
vim.keymap.set("n", "<C-c>", ':let @+ = expand("%")<CR>', {}) -- Copy current relative filepath to clipboard

vim.keymap.set("i", "<C-w>", "<Up>", {}) -- Mini jumps :)
vim.keymap.set("i", "<C-a>", "<Left>", {})
vim.keymap.set("i", "<C-s>", "<Down>", {})
vim.keymap.set("i", "<C-d>", "<Right>", {})

-- Git
vim.keymap.set("n", "<leader>gh", ":Gitsigns preview_hunk<CR>", {})
vim.keymap.set("n", "<leader>gsd", ":Gsplitdiff<CR>", {})
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", {})

-- Pickers
vim.keymap.set("n", "<leader>ff", ":Pick files<CR>", {})
vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>", {})
vim.keymap.set("n", "<leader>fh", ":Pick git_hunks<CR>", {})

-- LSP
vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {})
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {})

vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, {})

-- Toggle diagnostic virtual text
local function toggle_virtual_text()
  local current_virtual_text = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current_virtual_text })
end

vim.diagnostic.config({ virtual_text = false, underline = false })
vim.keymap.set("n", "<leader>ld", toggle_virtual_text, { silent = true })
