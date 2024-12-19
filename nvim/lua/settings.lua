-- Options --
vim.g.mapleader = vim.keycode('<Space>')
vim.o.termguicolors = true
-- vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.swapfile = false
vim.o.number = true
vim.o.wrap = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.showtabline = 2
vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.mousescroll = "ver:3,hor:0"
vim.o.scrolloff = 10
vim.o.pumheight = 10

-- Bindings --
vim.keymap.set("n", "<leader>te", ":Ex<CR>", {})         -- Explore
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", {})     -- New tab
vim.keymap.set("n", "<leader>tN", ":0tabnew<CR>", {})    -- New tab to the far left
vim.keymap.set("n", "<leader>tl", ":tabmove +1<CR>", {}) -- Move tab to the right
vim.keymap.set("n", "<leader>th", ":tabmove -1<CR>", {}) -- Move tab to the left
vim.keymap.set("n", "<leader>td", ":tab split<CR>", {})  -- Duplicate tab
vim.keymap.set("n", "<leader>bdt", ":bdelete<CR>", {})   -- Delete current buffers
vim.keymap.set("n", "<leader>bda", ":%bdelete<CR>", {})  -- Delete all buffers

vim.keymap.set("n", "<TAB>", "gt", {})                   -- Tabs
vim.keymap.set("n", "<S-TAB>", "gT", {})

vim.keymap.set("v", "<C-u>", ":move '<-2<CR>gv=gv", {}) -- Move selecion up/down
vim.keymap.set("v", "<C-d>", ":move '>+1<CR>gv=gv", {})
vim.keymap.set("v", ">", ">gv", {})                     -- Indention
vim.keymap.set("v", "<", "<gv", {})

vim.keymap.set("v", "gy", '"+y', {})                       -- Copy to clipboard
vim.keymap.set("n", "gy", ':let @+ = expand("%")<CR>', {}) -- Copy current relative filepath to clipboard
vim.keymap.set({ "n", "v" }, "gp", '"+p', {})              -- Paste from clipboard

vim.keymap.set("i", "<C-w>", "<Up>", {})                   -- Mini jumps
vim.keymap.set("i", "<C-a>", "<Left>", {})
vim.keymap.set("i", "<C-s>", "<Down>", {})
vim.keymap.set("i", "<C-d>", "<Right>", {})

-- Pickers
vim.keymap.set("n", "<leader>ff", ":Pick files<CR>", {})
vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>", {})
vim.keymap.set("n", "<leader>fb", ":Pick buffers<CR>", {})
vim.keymap.set("n", "<leader>fh", ":Pick git_hunks<CR>", {})
vim.keymap.set("n", "<leader>fc", ":Pick git_commits<CR>", {})
vim.keymap.set("n", "<leader>fe", ":Pick explorer<CR>", {})
vim.keymap.set("n", "<leader>fd", ":Pick diagnostic<CR>", {})
vim.keymap.set("n", "<leader>f:", ":Pick commands<CR>", {})
vim.keymap.set("n", "<leader>fm", ":Pick marks<CR>", {})
vim.keymap.set("n", "<leader>fo", ":Pick oldfiles<CR>", {})

-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts)
    vim.keymap.set("n", "grr", ":Pick lsp scope='references'<CR>", {})
    vim.keymap.set("n", "grd", ":Pick lsp scope='declaration'<CR>", {})

    vim.keymap.set({ 'n', 'x' }, 'gq', ':lua vim.lsp.buf.format({async = true})<CR>', opts)
    vim.keymap.set('n', 'grn', ':lua vim.lsp.buf.rename()<CR>', opts)
    vim.keymap.set('n', 'gra', ':lua vim.lsp.buf.code_action()<CR>', opts)

    vim.keymap.set("n", "gri", ":Pick lsp scope='implementation'<CR>", {})
    vim.keymap.set("n", "grt", ":Pick lsp scope='type_declaration'<CR>", {})

    vim.keymap.set('n', 'gO', ':lua vim.lsp.buf.document_symbol()<CR>', opts)
    vim.keymap.set({ 'i', 's' }, '<C-s>', ':lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.keymap.set('n', 'K', ':lua vim.lsp.buf.hover()<CR>', opts)
  end,
})

-- Toggle hardtime
vim.keymap.set("n", "<leader>tht", ":Hardtime toggle<CR>", {})

-- Toggle wrap
vim.keymap.set("n", "<leader>tw", function() vim.o.wrap = not vim.o.wrap end, {})

-- Toggle relativenumbers
vim.keymap.set("n", "<leader>trn", function() vim.o.relativenumber = not vim.o.relativenumber end, {})

-- Toggle diagnostic virtual text
vim.diagnostic.config({ virtual_text = false, underline = false })
vim.keymap.set(
  "n",
  "<leader>ld",
  function()
    local current_virtual_text = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = not current_virtual_text })
  end,
  { silent = true }
)
