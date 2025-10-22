-- Options --
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.mouse = "a"
vim.o.mousescroll = "ver:2,hor:0"
vim.o.undofile = true
vim.o.swapfile = false
vim.o.wrap = false
vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.showmode = false
vim.o.shiftwidth = 2
vim.o.showtabline = 2
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.winborder = "single"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.inccommand = "split"
vim.o.confirm = true


-- Bindings --
vim.keymap.set("n", "<leader>te", ":Ex<CR>", {})         -- Explore
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", {})     -- New tab
vim.keymap.set("n", "<leader>tN", ":0tabnew<CR>", {})    -- New tab to the far left
vim.keymap.set("n", "<leader>q", ":quit<CR>", {})        -- Close tab
vim.keymap.set("n", "<leader>w", ":write<CR>", {})       -- Wrtie tab
vim.keymap.set("n", "<leader>th", ":tabmove -1<CR>", {}) -- Move tab left/right
vim.keymap.set("n", "<leader>tl", ":tabmove +1<CR>", {})
vim.keymap.set("n", "<leader>td", ":tab split<CR>", {})  -- Duplicate tab
vim.keymap.set("n", "<S-TAB>", "gT", {})                 -- Switch tabs left/right
vim.keymap.set("n", "<TAB>", "gt", {})
vim.keymap.set("v", "<C-u>", ":move '<-2<CR>gv=gv", {})  -- Move selecion up/down
vim.keymap.set("v", "<C-d>", ":move '>+1<CR>gv=gv", {})
vim.keymap.set("v", ">", ">gv", {})                      -- Move selection left/right
vim.keymap.set("v", "<", "<gv", {})
vim.keymap.set("i", "<C-f>", "<Right>")                  -- Mini jumps
vim.keymap.set("i", "<C-b>", "<Left>")

-- Clipboard
vim.keymap.set("v", "gy", function()
  vim.cmd('normal! "+y')
  vim.notify("Copied to clipboard")
end, { desc = "Copy to clipboard" })

vim.keymap.set("n", "gy", function()
  local line = vim.fn.getline(".")
  local trimmed = line:gsub("^%s+", "")
  vim.fn.setreg("+", trimmed)
  vim.notify("Copied line to clipboard")
end, { desc = "Copy line to clipboard" })

vim.keymap.set("n", "gn", function()
  vim.fn.setreg("+", vim.fn.expand("%:t"))
  vim.notify("Copied: " .. vim.fn.expand("%:t"))
end, { desc = "Copy filename" })

vim.keymap.set("n", "gf", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
  vim.notify("Copied: " .. vim.fn.expand("%"))
end, { desc = "Copy relative file path" })

vim.keymap.set("n", "gF", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
  vim.notify("Copied: " .. vim.fn.expand("%:p"))
end, { desc = "Copy absolute file path" })

vim.keymap.set({ "n", "v" }, "gp", function()
  vim.cmd('normal! "+p')
end, { desc = "Paste from clipboard" })

vim.keymap.set({ "n", "v" }, "gP", function()
  vim.cmd('normal! "+P')
end, { desc = "Paste before clipboard" })

-- Toggle wrap
vim.keymap.set("n", "<leader>tw", function()
  vim.o.wrap = not vim.o.wrap
  vim.notify("Wrap: " .. tostring(vim.o.wrap))
end, {})

-- Toggle relativenumbers
vim.keymap.set("n", "<leader>tr", function()
  vim.o.relativenumber = not vim.o.relativenumber
  vim.notify("Relative numbers: " .. tostring(vim.o.relativenumber))
end, {})

-- Delete all buffers
vim.keymap.set("n", "<leader>bda", function()
  vim.cmd('%bdelete!')
  vim.notify("Deleted all buffers")
end, {})

-- Delete all hidden buffers
vim.keymap.set("n", "<leader>bdh", function()
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
        and not vim.api.nvim_get_option_value("modified", {}) then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end

  vim.notify("Deleted hidden buffers")
end, {})

-- Expand quickfix list into new tabs
vim.keymap.set("n", "<leader>co", function()
  if vim.bo.buftype ~= "quickfix" then return end

  local qf_winid = vim.fn.win_getid()
  local qf_list = vim.fn.getqflist()

  for _, entry in ipairs(qf_list) do
    if entry.valid == 1 and entry.bufnr > 0 then
      local filepath = vim.fn.bufname(entry.bufnr)
      if filepath and filepath ~= "" then
        vim.cmd("tabnew " .. vim.fn.fnameescape(filepath))
      end
    end
  end

  vim.fn.win_gotoid(qf_winid)
  vim.cmd("close")

  vim.notify("Expanded quickfix list into new tabs")
end, {})

-- Auto resize splits
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})
