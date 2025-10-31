local M = {}
local H = {}
local menus = {}

function M.create_menu(config)
  if type(config) ~= "table" then
    error("create_menu: config must be a table", 2)
  end

  if not config.name or type(config.name) ~= "string" or config.name == "" then
    error("create_menu: 'name' must be a non-empty string", 2)
  end

  -- Validate UpperCamelCase format
  if not config.name:match("^[A-Z][A-Za-z0-9]*$") then
    error("create_menu: 'name' must be in UpperCamelCase format (e.g., 'MyMenu', 'TempTogglable')", 2)
  end

  if not config.items or type(config.items) ~= "table" or #config.items == 0 then
    error("create_menu: 'items' must be a non-empty table", 2)
  end

  for i, item in ipairs(config.items) do
    if type(item) ~= "table" then
      error(string.format("create_menu: item %d must be a table", i), 2)
    end
    if not item.label or type(item.label) ~= "string" then
      error(string.format("create_menu: item %d must have a 'label' string", i), 2)
    end
    if not item.name or type(item.name) ~= "string" then
      error(string.format("create_menu: item %d must have a 'name' string", i), 2)
    end
    if item.callback and type(item.callback) ~= "function" then
      error(string.format("create_menu: item %d 'callback' must be a function if provided", i), 2)
    end
    if item.enable ~= nil and type(item.enable) ~= "boolean" then
      error(string.format("create_menu: item %d 'enable' must be a boolean if provided", i), 2)
    end
  end

  if config.callback and type(config.callback) ~= "function" then
    error("create_menu: 'callback' must be a function if provided", 2)
  end

  local opts = {
    title = config.title or "Menu",
    desc = config.desc or "",
    togglable = config.togglable ~= nil and config.togglable or false,
    auto_close = config.auto_close ~= nil and config.auto_close or false,
    row = config.row or vim.o.lines - 1,
    col = config.col or 0,
  }

  local items = vim.deepcopy(config.items)
  if opts.togglable then
    for _, item in ipairs(items) do
      if item.enable == nil then
        item.enable = false
      end
    end
  end

  local lines = H.item_lines(items, opts.togglable)
  local width = math.min(math.max(H.longest_line_len(lines) + 2, 70), vim.o.columns)

  opts.width = width
  opts.height = #lines

  local menu_name = config.name

  menus[menu_name] = {
    name = menu_name,
    items = items,
    lines = lines,
    selected = 1,
    callback = config.callback,
    win = nil,
    buf = nil,
    opts = opts,
  }

  vim.api.nvim_create_user_command(
    menu_name,
    function() M.open_menu(menu_name) end,
    { desc = opts.desc ~= "" and opts.desc or opts.title }
  )

  return {
    name = menu_name,
    open = function() M.open_menu(menu_name) end,
    close = function() H.close_menu_by_name(menu_name) end,
  }
end

function M.open_menu(name)
  local menu = menus[name]
  if not menu then return end

  if menu.win and vim.api.nvim_win_is_valid(menu.win) then
    H.close_menu(menu)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, menu.lines)
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = 'togglemenu'

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

  menu.win, menu.buf = win, buf

  vim.wo[win].cursorline = true
  vim.wo[win].wrap = false
  vim.api.nvim_win_set_cursor(win, { menu.selected, 0 })

  local keys = {
    ["q"] = function() H.close_menu(menu) end,
    ["<Esc>"] = function() H.close_menu(menu) end,
    ["<CR>"] = function() H.trigger_selected(menu) end,
    ["<Space>"] = function() H.trigger_selected(menu) end,
    ["j"] = function() H.move_cursor(menu, 1) end,
    ["k"] = function() H.move_cursor(menu, -1) end,
    ["<Down>"] = function() H.move_cursor(menu, 1) end,
    ["<Up>"] = function() H.move_cursor(menu, -1) end,
  }

  for lhs, fn in pairs(keys) do
    vim.keymap.set('n', lhs, fn, { buffer = buf, noremap = true, silent = true })
  end

  vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    buffer = buf,
    once = true,
    callback = function() H.close_menu(menu) end,
  })
end

function H.item_lines(items, togglable)
  local lines = {}
  for _, item in ipairs(items) do
    local line = togglable
        and string.format("  %s %s", item.enable and "●" or "○", item.label)
        or ("  " .. item.label)
    table.insert(lines, line)
  end
  return lines
end

function H.longest_line_len(lines)
  local max_len = 0
  for _, str in ipairs(lines) do
    max_len = math.max(max_len, #str)
  end
  return max_len
end

function H.close_menu(menu)
  if not menu.win or not vim.api.nvim_win_is_valid(menu.win) then return end
  local ok, cursor = pcall(vim.api.nvim_win_get_cursor, menu.win)
  if ok and cursor then menu.selected = cursor[1] end

  pcall(vim.api.nvim_win_close, menu.win, true)
  if menu.buf and vim.api.nvim_buf_is_valid(menu.buf) then
    pcall(vim.api.nvim_buf_delete, menu.buf, { force = true })
  end
  menu.win, menu.buf = nil, nil
end

function H.close_menu_by_name(name)
  local menu = menus[name]
  if menu then
    H.close_menu(menu)
  end
end

function H.move_cursor(menu, delta)
  local line = vim.api.nvim_win_get_cursor(menu.win)[1]
  local new_line = ((line - 1 + delta) % #menu.lines) + 1
  vim.api.nvim_win_set_cursor(menu.win, { new_line, 0 })
end

function H.trigger_selected(menu)
  local line = vim.api.nvim_win_get_cursor(menu.win)[1]
  local item = menu.items[line]
  if not item then return end

  local should_close = menu.opts.auto_close

  if menu.opts.togglable then
    item.enable = not item.enable
    menu.lines = H.item_lines(menu.items, true)

    vim.bo[menu.buf].modifiable = true
    vim.api.nvim_buf_set_lines(menu.buf, 0, -1, false, menu.lines)
    vim.bo[menu.buf].modifiable = false
  end

  if item.callback then item.callback(item) end
  if menu.callback then menu.callback(item) end

  if should_close then
    H.close_menu(menu)
  end
end

return M
