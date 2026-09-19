-- Common bindings
vim.keymap.set("n", "<leader>te", ":Ex<CR>", {})         -- Explore
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", {})     -- New tab
vim.keymap.set("n", "<leader>tN", ":0tabnew<CR>", {})    -- New tab to the far left
vim.keymap.set("n", "<leader>q", ":quit<CR>", {})        -- Close tab
vim.keymap.set("n", "<leader>w", ":write<CR>", {})       -- Write tab
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

-- Picker bindings
local function picker_opts()
  return { layout = { preset = "ivy_split", layout = { height = 0.3 } } }
end

local function picker_opts_command()
  return {
    layout = {
      hidden = { "preview" },
      layout = {
        backdrop = false,
        row = 10,
        width = 0.4,
        min_width = 80,
        height = 0.4,
        border = "none",
        box = "vertical",
        { win = "input", height = 1, border = true, title = "{title} {live} {flags}", title_pos = "center" },
        { win = "list", border = true },
        { win = "preview", title = "{preview}", border = true },
      },
    },
  }
end

vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files(picker_opts()) end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.grep(picker_opts()) end, { desc = "Grep (Live)" })
vim.keymap.set("n", "<leader>fs", function() Snacks.picker.git_status(picker_opts()) end, { desc = "Git Hunks" })
vim.keymap.set("n", "<leader>fc", function() Snacks.picker.git_log(picker_opts()) end, { desc = "Git Commits" })
vim.keymap.set("n", "<leader>fd", function() Snacks.picker.diagnostics(picker_opts()) end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>f:", function() Snacks.picker.commands(picker_opts_command()) end, { desc = "Commands" })
vim.keymap.set("n", "<leader>fh", function() Snacks.picker.command_history(picker_opts_command()) end, { desc = "Command History" })

vim.keymap.set("n", "<C-n>", function()
  local explorer = Snacks.picker.get({ source = "explorer" })[1]
  if not explorer then
    Snacks.picker.explorer({ focus = false })
  elseif explorer:is_focused() then
    if explorer.main and vim.api.nvim_win_is_valid(explorer.main) then
      vim.api.nvim_set_current_win(explorer.main)
    else
      vim.cmd("wincmd p")
    end
  else
    explorer:focus("list")
  end
end, { desc = "File Explorer" })

vim.keymap.set("n", "<C-S-n>", function()
  local explorer = Snacks.picker.get({ source = "explorer" })[1]
  if explorer then explorer:close() end
end, { desc = "Close File Explorer" })

-- DiffView bindings
vim.keymap.set("n", "<leader>go", "<cmd>DiffviewOpen<cr>", { desc = "Diff (index)" })
vim.keymap.set({ "n", "v" }, "<leader>gl", ":DiffviewFileHistory<CR>", { desc = "Line history" })

-- MiniDiff
vim.keymap.set("n", "<leader>gd", function() MiniDiff.toggle_overlay(0) end)

-- Lsp bindings
vim.keymap.set("n", "grr", function() Snacks.picker.lsp_references(picker_opts()) end, { desc = "LSP References" })
vim.keymap.set("n", "grd", function() Snacks.picker.lsp_declarations(picker_opts()) end, { desc = "LSP Declaration" })
vim.keymap.set("n", "gri", function() Snacks.picker.lsp_implementations(picker_opts()) end, { desc = "LSP Implementation" })
vim.keymap.set("n", "grt", function() Snacks.picker.lsp_type_definitions(picker_opts()) end, { desc = "LSP Type Definition" })
vim.keymap.set("n", "grs", function() Snacks.picker.lsp_symbols(picker_opts()) end, { desc = "LSP Symbols (Buffer)" })
vim.keymap.set("n", "grS", function() Snacks.picker.lsp_workspace_symbols(picker_opts()) end, { desc = "LSP Symbols (Workspace)" })
vim.keymap.set("n", "<leader>dd", function() Snacks.picker.diagnostics(picker_opts()) end, { desc = "Diagnostics (Buffer)" })
vim.keymap.set("n", "<leader>dD", function() Snacks.picker.diagnostics_buffer(picker_opts()) end, { desc = "Diagnostics (All)" })
vim.keymap.set({ "n", "x" }, "gq", function() vim.lsp.buf.format({ async = true }) end, { desc = "LSP Format" })
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "LSP Definition" })
vim.keymap.set("n", "gD", function()
  vim.cmd("tab split")
  Snacks.picker.lsp_definitions()
end, { desc = "LSP Definition in new tab" })

-- Resize mode
local resize_keys = {
  [">"] = "vertical resize +4",
  ["<"] = "vertical resize -4",
  ["+"] = "resize +4",
  ["-"] = "resize -4",
}

local function sticky_resize(cmd)
  vim.notify("Resize mode", vim.log.levels.WARN, { id = "resize_mode", timeout = false })
  vim.cmd(cmd)
  vim.cmd("redraw")

  while true do
    local key = vim.fn.getchar()
    local action = resize_keys[type(key) == "number" and vim.fn.nr2char(key) or key]
    if action then
      vim.cmd(action)
      vim.cmd("redraw")
    else
      if type(key) == "number" then vim.fn.feedkeys(vim.fn.nr2char(key), "n") end
      Snacks.notifier.hide("resize_mode")
      break
    end
  end
end

for key, cmd in pairs(resize_keys) do
  vim.keymap.set("n", "<C-w>" .. key, function() sticky_resize(cmd) end)
end

-- Diagnostic bindings
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })

vim.keymap.set("n", "<leader>ld", function()
  local current_virtual_lines = vim.diagnostic.config().virtual_lines

  vim.diagnostic.config({
    virtual_lines = not current_virtual_lines
  })
end, { desc = "Toggle diagnostic virtual lines" })

-- Copy line (trimmed)
vim.keymap.set("n", "<leader>y", function()
  local line = vim.fn.getline(".")
  local trimmed = vim.trim(line)
  vim.fn.setreg("+", trimmed)
  vim.notify("Copied line")
end, { desc = "Copy trimmed line" })

-- Copy Selection
vim.keymap.set("v", "<leader>y", function()
  vim.cmd('normal! "+y')
  local text = vim.fn.getreg("+")
  local cleaned = text:gsub("\n$", "")
  vim.fn.setreg("+", cleaned, "v")
  vim.notify("Copied selection")
end, { desc = "Copy selection" })

-- Copy relative path
vim.keymap.set("n", "<leader>r", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify("Copied relative: " .. path)
end, { desc = "Copy relative path" })

-- Copy absolute path
vim.keymap.set("n", "<leader>F", function()
  local full_path = vim.fn.expand("%:p")
  vim.fn.setreg("+", full_path)
  vim.notify("Copied absolute: " .. full_path)
end, { desc = "Copy absolute path" })

vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })

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

-- No highlight
vim.keymap.set("n", "<leader>noh", function()
  vim.cmd("noh")
end, {})
