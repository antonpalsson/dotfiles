local Menu = {}
local H = {}

Menu.config = {
  min_width = 70,
  max_width = function() return vim.o.columns end,
  border = 'single',
  title_padding = ' ',
  command_desc_fmt = '%s menu',
  auto_register = true,
  notify = true,
  notify_level = vim.log.levels.INFO,
}

H.default_config = vim.deepcopy(Menu.config)

Menu.setup = function(config)
  _G.Menu = Menu

  config = H.setup_config(config)

  H.apply_config(config)
end

H.setup_config = function(config)
  H.check_type('config', config, 'table', true)

  config = vim.tbl_deep_extend('force', vim.deepcopy(H.default_config), config or {})

  H.check_type('min_width', config.min_width, 'number')
  H.check_type('max_width', config.max_width, 'function')
  H.check_type('border', config.border, 'string')
  H.check_type('title_padding', config.title_padding, 'string')
  H.check_type('command_desc_fmt', config.command_desc_fmt, 'string')
  H.check_type('auto_register', config.auto_register, 'boolean')
  H.check_type('notify', config.notify, 'boolean')
  H.check_type('notify_level', config.notify_level, 'number')

  return config
end

H.apply_config = function(config) Menu.config = config end

H.get_config = function(local_override)
  return vim.tbl_deep_extend('force', Menu.config, vim.b.menu_config or {}, local_override or {})
end

H.check_type = function(name, val, ref, allow_nil)
  if (allow_nil and val == nil) or type(val) == ref then return end

  error(string.format('(menu) `%s` should be %s, not %s', name, ref, type(val)), 0)
end

H.notify = function(msg, level)
  local cfg = H.get_config()

  if not cfg.notify then return end

  vim.notify(msg, level or cfg.notify_level)
end

local menus = {}

Menu.create = function(config)
  if type(config) ~= 'table' then error('create: config must be table', 2) end

  if not config.name or type(config.name) ~= 'string' or config.name == '' then
    error("create: 'name' must be non-empty string", 2)
  end

  if not config.name:match("^[A-Za-z]+$") then
    error("create: 'name' must only contain letters", 2)
  end

  if not config.items or type(config.items) ~= 'table' or #config.items == 0 then
    error("create: 'items' must be a non-empty table", 2)
  end

  for i, item in ipairs(config.items) do
    if type(item) ~= 'table' then error(string.format('create: item %d must be table', i), 2) end
    if type(item.label) ~= 'string' then error(string.format("create: item %d needs 'label' string", i), 2) end
    if item.name and type(item.name) ~= 'string' then
      error(string.format("create: item %d needs 'name' string", i), 2)
    end
    if item.callback and type(item.callback) ~= 'function' then
      error(string.format("create: item %d 'callback' must be function", i), 2)
    end
    if item.enable ~= nil and type(item.enable) ~= 'boolean' then
      error(string.format("create: item %d 'enable' must be boolean", i), 2)
    end
  end

  if config.callback and type(config.callback) ~= 'function' then
    error("create: 'callback' must be function", 2)
  end

  local opts = {
    title = config.title or 'Menu',
    desc = config.desc or '',
    togglable = config.togglable == true,
    auto_close = config.auto_close == true,
    row = config.row or (vim.o.lines - 1),
    col = config.col or 0,
  }

  local items = vim.deepcopy(config.items)

  if opts.togglable then
    for _, item in ipairs(items) do
      if item.enable == nil then item.enable = false end
    end
  end

  local lines = H.item_lines(items, opts.togglable)
  local cfg = H.get_config()
  local width = math.min(math.max(H.longest_line_len(lines) + 2, cfg.min_width), cfg.max_width())

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

  if cfg.auto_register then
    local desc = (cfg.command_desc_fmt ~= '' and string.format(cfg.command_desc_fmt, menu_name)) or opts.title

    pcall(vim.api.nvim_del_user_command, menu_name)

    vim.api.nvim_create_user_command(menu_name, function()
      Menu.open(menu_name)
    end, { desc = desc })
  end

  return {
    name = menu_name,
    open = function() Menu.open(menu_name) end,
    close = function() H.close_menu_by_name(menu_name) end,
  }
end

Menu.open = function(name)
  local menu = menus[name]

  if not menu then return end

  menu.origin_win = vim.api.nvim_get_current_win()

  if menu.win and vim.api.nvim_win_is_valid(menu.win) then
    H.close_menu(menu)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, menu.lines)
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = 'togglemenu'

  local cfg = H.get_config()

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = menu.opts.width,
    height = menu.opts.height,
    row = menu.opts.row,
    col = menu.opts.col,
    style = 'minimal',
    border = cfg.border,
    title = cfg.title_padding .. menu.opts.title .. cfg.title_padding,
    title_pos = 'left',
  })

  menu.win, menu.buf = win, buf

  vim.wo[win].cursorline = true
  vim.wo[win].wrap = false
  vim.api.nvim_win_set_cursor(win, { menu.selected, 0 })

  local keys = {
    ['q'] = function() H.close_menu(menu) end,
    ['<Esc>'] = function() H.close_menu(menu) end,
    ['<CR>'] = function() H.trigger_selected(menu) end,
    ['<Space>'] = function() H.trigger_selected(menu) end,
    ['j'] = function() H.move_cursor(menu, 1) end,
    ['k'] = function() H.move_cursor(menu, -1) end,
    ['<Down>'] = function() H.move_cursor(menu, 1) end,
    ['<Up>'] = function() H.move_cursor(menu, -1) end,
  }

  for lhs, fn in pairs(keys) do
    vim.keymap.set('n', lhs, fn, { buffer = buf, noremap = true, silent = true })
  end

  vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
    buffer = buf,
    once = true,
    callback = function() H.close_menu(menu) end,
  })
end

H.item_lines = function(items, togglable)
  local lines = {}

  for _, item in ipairs(items) do
    local line = togglable
        and string.format('  %s %s', item.enable and '●' or '○', item.label)
        or ('  ' .. item.label)
    table.insert(lines, line)
  end

  return lines
end

H.longest_line_len = function(lines)
  local max_len = 0

  for _, str in ipairs(lines) do
    max_len = math.max(max_len, #str)
  end

  return max_len
end

H.close_menu = function(menu)
  if not menu.win or not vim.api.nvim_win_is_valid(menu.win) then return end

  local ok, cursor = pcall(vim.api.nvim_win_get_cursor, menu.win)

  if ok and cursor then menu.selected = cursor[1] end

  pcall(vim.api.nvim_win_close, menu.win, true)

  if menu.buf and vim.api.nvim_buf_is_valid(menu.buf) then
    pcall(vim.api.nvim_buf_delete, menu.buf, { force = true })
  end

  menu.win, menu.buf, menu.origin_win = nil, nil, nil
end

H.close_menu_by_name = function(name)
  local menu = menus[name]

  if menu then H.close_menu(menu) end
end

H.move_cursor = function(menu, delta)
  local line = vim.api.nvim_win_get_cursor(menu.win)[1]
  local new_line = ((line - 1 + delta) % #menu.lines) + 1

  vim.api.nvim_win_set_cursor(menu.win, { new_line, 0 })
end

H.run_in_origin = function(menu, callback)
  if menu.origin_win and vim.api.nvim_win_is_valid(menu.origin_win) then
    vim.api.nvim_win_call(menu.origin_win, callback)
  else
    callback()
  end
end

H.trigger_selected = function(menu)
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

  local function exec_callbacks()
    if item.callback then item.callback(item) end
    if menu.callback then menu.callback(item) end
  end

  H.run_in_origin(menu, exec_callbacks)
  if should_close then H.close_menu(menu) end
end

return Menu
