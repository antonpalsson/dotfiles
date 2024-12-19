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

-- Expand quickfix list into new tabs
vim.keymap.set(
  "n",
  "<leader>co",
  function()
    if vim.bo.buftype ~= 'quickfix' then return end

    local qf_winid = vim.fn.win_getid()
    local qf_list = vim.fn.getqflist()

    for _, entry in ipairs(qf_list) do
      if entry.valid == 1 and entry.bufnr > 0 then
        local filepath = vim.fn.bufname(entry.bufnr)
        if filepath and filepath ~= '' then
          vim.cmd('tabnew ' .. vim.fn.fnameescape(filepath))
        end
      end
    end

    vim.fn.win_gotoid(qf_winid)
    vim.cmd('close')
  end,
  {}
)

-- Delete all buffers
vim.keymap.set("n", "<leader>bda", ":%bdelete<CR>", {})

-- Delete all hidden buffers
vim.keymap.set(
  'n',
  '<leader>bdh',
  function()
    local buffers = vim.api.nvim_list_bufs()

    local visible_buffers = {}
    for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
        local buf = vim.api.nvim_win_get_buf(win)
        visible_buffers[buf] = true
      end
    end

    for _, buf in ipairs(buffers) do
      if not visible_buffers[buf]
          and vim.api.nvim_buf_is_loaded(buf)
          and not vim.api.nvim_buf_get_option(buf, 'modified') then
        vim.api.nvim_buf_delete(buf, { force = false })
      end
    end
  end,
  {}
)
