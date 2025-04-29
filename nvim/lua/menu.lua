local M = {}
local H = {}

local menus = {}

function M.create_menu(name, togglable, items, callback, opts)
  local lines = H.item_lines(items, togglable)

  local longest_line = ""
  for _, str in ipairs(lines) do
    if #str > #longest_line then
      longest_line = str
    end
  end

  opts = vim.tbl_deep_extend('force', {
    title = "Menu",
    desc = "Menu desc",
    width = math.min(math.max(#longest_line + 2, 70), vim.o.columns),
    height = #lines,
    row = vim.o.lines - 1,
    col = 0,
  }, opts or {})

  menus[name] = {
    name = name,
    items = items,
    lines = lines,
    selected = 1,
    togglable = togglable,
    callback = callback,
    win = nil,
    buf = nil,
    opts = opts,
  }

  vim.api.nvim_create_user_command(name:gsub("^%l", string.upper), function()
    M.open_menu(name)
  end, { desc = opts.desc })
end

function M.open_menu(name)
  local menu = menus[name]
  if not menu then return end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, menu.lines)
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  vim.api.nvim_set_option_value('filetype', 'togglemenu', { buf = buf })

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = menu.opts.width,
    height = menu.opts.height,
    row = menu.opts.row,
    col = menu.opts.col,
    style = 'minimal',
    border = 'single',
    title = " " .. menu.opts.title .. " ",
    title_pos = 'left'
  })

  menu.win = win
  menu.buf = buf

  vim.api.nvim_set_option_value('cursorline', true, { win = win })
  vim.api.nvim_set_option_value('wrap', false, { win = win })
  vim.api.nvim_win_set_cursor(win, { menu.selected, 0 })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '',
    { callback = function() H.close_menu(menu) end, noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', '',
    { callback = function() H.close_menu(menu) end, noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '',
    { callback = function() H.trigger_selected(menu) end, noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Space>', '',
    { callback = function() H.trigger_selected(menu) end, noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'j', '',
    { callback = function() H.move_cursor(menu, 1) end, noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'k', '',
    { callback = function() H.move_cursor(menu, -1) end, noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Down>', '',
    { callback = function() H.move_cursor(menu, 1) end, noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Up>', '',
    { callback = function() H.move_cursor(menu, -1) end, noremap = true, silent = true })

  vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    buffer = buf,
    once = true,
    callback = function() H.close_menu(menu) end
  })
end

function H.item_lines(items, togglable)
  local lines = {}
  for _, item in ipairs(items) do
    if togglable then
      table.insert(lines, string.format("  %s %s", item.enable and "●" or "○", item.label))
    else
      table.insert(lines, string.format("  %s", item.label))
    end
  end

  return lines
end

function H.close_menu(menu)
  local current_line = vim.api.nvim_win_get_cursor(menu.win)[1]
  menu.selected = current_line

  pcall(vim.api.nvim_win_close, menu.win, true)
  pcall(vim.api.nvim_buf_delete, menu.buf, { force = true })

  menu.win = nil
  menu.buf = nil
end

function H.move_cursor(menu, delta)
  local current_line = vim.api.nvim_win_get_cursor(menu.win)[1]
  local new_line = ((current_line - 1 + delta) % #menu.lines) + 1

  vim.api.nvim_win_set_cursor(menu.win, { new_line, 0 })
end

function H.trigger_selected(menu)
  local current_line = vim.api.nvim_win_get_cursor(menu.win)[1]
  local item = menu.items[current_line]

  if item then
    if menu.togglable then
      item.enable = not item.enable
      menu.lines = H.item_lines(menu.items, true)
    end

    if item.callback then
      item.callback(item)
    end

    if menu.callback then
      menu.callback(item)
    end

    H.close_menu(menu)

    if menu.togglable then
      M.open_menu(menu.name)
    end
  end
end

return M
