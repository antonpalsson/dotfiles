local Session = {}
local H = {}

Session.config = {
  session_dir     = vim.fn.stdpath('data') .. '/sessions',
  file_extension  = '.txt',
  auto_create_dir = true,
  auto_save       = false,
  auto_load       = false,
  notify          = true,
  notify_level    = vim.log.levels.INFO,
  command_name    = 'Session',
}

H.default_config = vim.deepcopy(Session.config)

Session.setup = function(config)
  _G.Session = Session

  config = H.setup_config(config)
  H.apply_config(config)

  if config.auto_create_dir then
    vim.fn.mkdir(H.get_config().session_dir, 'p')
  end

  if config.auto_save then
    vim.api.nvim_create_autocmd('VimLeavePre', {
      group = vim.api.nvim_create_augroup('SessionAutoSave', { clear = true }),
      callback = Session.save,
    })
  end

  if config.auto_load then
    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('SessionAutoLoad', { clear = true }),
      nested = true,
      callback = function()
        if vim.fn.argc() ~= 0 then return end
        local path = H.get_session_path()
        if path and vim.fn.filereadable(path) == 1 then Session.load() end
      end,
    })
  end

  H.create_user_command()
end

H.setup_config = function(config)
  H.check_type('config', config, 'table', true)

  config = vim.tbl_deep_extend('force', H.default_config, config or {})

  H.check_type('session_dir', config.session_dir, 'string')
  H.check_type('file_extension', config.file_extension, 'string')
  H.check_type('auto_create_dir', config.auto_create_dir, 'boolean')
  H.check_type('auto_save', config.auto_save, 'boolean')
  H.check_type('auto_load', config.auto_load, 'boolean')
  H.check_type('notify', config.notify, 'boolean')
  H.check_type('notify_level', config.notify_level, 'number')
  H.check_type('command_name', config.command_name, 'string')

  return config
end

H.apply_config = function(config) Session.config = config end

H.get_config = function()
  return vim.tbl_deep_extend('force', Session.config, vim.b.session_config or {})
end

H.get_repo_name = function()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")

  if not handle then return nil end

  local path = handle:read("*l")
  handle:close()

  if not path or path == '' then return nil end

  return vim.fn.fnamemodify(path, ":t")
end

H.get_session_path = function()
  local cfg = H.get_config()
  local repo = H.get_repo_name()

  if not repo then return nil, nil, "Not in a git repository" end

  local path = cfg.session_dir .. '/' .. repo .. cfg.file_extension

  return path, repo, nil
end

H.notify = function(msg, level)
  local cfg = H.get_config()

  if not cfg.notify then return end

  vim.notify(msg, level or cfg.notify_level)
end

H.check_type = function(name, val, ref, allow_nil)
  if (allow_nil and val == nil) or type(val) == ref then return end

  error(string.format('(session) `%s` should be %s, not %s', name, ref, type(val)), 0)
end

H.get_open_files = function()
  local seen = {}
  local files = {}

  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if not seen[buf] then
        local path = vim.api.nvim_buf_get_name(buf)
        local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
        if path ~= '' and buftype == '' then
          local cursor = vim.api.nvim_win_get_cursor(win)
          table.insert(files, { path = path, line = cursor[1] })
          seen[buf] = true
        end
      end
    end
  end

  return files
end

Session.save = function()
  local path, repo, err = H.get_session_path()

  if not path or not repo then
    H.notify("Session save failed: " .. (err or 'unknown'), vim.log.levels.ERROR)
    return
  end

  local files = H.get_open_files()

  if #files == 0 then
    H.notify("No open files to save", vim.log.levels.WARN)
    return
  end

  local file = io.open(path, 'w')
  if not file then
    H.notify("Session save failed: could not write to " .. path, vim.log.levels.ERROR)
    return
  end

  for _, entry in ipairs(files) do
    file:write(entry.path .. ':' .. entry.line .. '\n')
  end
  file:close()

  local summary = { "Session saved: " .. repo }
  for _, entry in ipairs(files) do
    table.insert(summary, "  " .. vim.fn.fnamemodify(entry.path, ':.') .. ':' .. entry.line)
  end
  H.notify(table.concat(summary, '\n'))
end

Session.load = function()
  local path, repo, err = H.get_session_path()

  if not path or not repo then
    H.notify("Session load failed: " .. (err or 'unknown'), vim.log.levels.ERROR)
    return
  end

  if vim.fn.filereadable(path) == 0 then
    H.notify("No session found for: " .. repo, vim.log.levels.WARN)
    return
  end

  local file = io.open(path, 'r')
  if not file then
    H.notify("Session load failed: could not read " .. path, vim.log.levels.ERROR)
    return
  end

  local entries = {}
  for line in file:lines() do
    local fpath, lnum = line:match("^(.+):(%d+)$")
    if fpath and lnum then
      table.insert(entries, { path = fpath, line = tonumber(lnum) })
    end
  end
  file:close()

  if #entries == 0 then
    H.notify("Session is empty: " .. repo, vim.log.levels.WARN)
    return
  end

  local opened = 0
  for _, entry in ipairs(entries) do
    if vim.fn.filereadable(entry.path) == 1 then
      if opened > 0 then vim.cmd('tabnew') end
      vim.cmd('edit ' .. vim.fn.fnameescape(entry.path))
      vim.api.nvim_win_set_cursor(0, { entry.line, 0 })
      opened = opened + 1
    end
  end

  if opened > 1 then vim.cmd('tabfirst') end

  H.notify("Session loaded: " .. repo)
end

Session.delete = function()
  local path, repo, err = H.get_session_path()

  if not path or not repo then
    H.notify("Session delete failed: " .. (err or 'unknown'), vim.log.levels.ERROR)
    return
  end

  if vim.fn.filereadable(path) == 0 then
    H.notify("No session found for: " .. repo, vim.log.levels.WARN)
    return
  end

  vim.fn.delete(path)
  H.notify("Session deleted: " .. repo)
end

Session.prune = function()
  local cfg = H.get_config()
  local files = vim.fn.glob(cfg.session_dir .. '/*' .. cfg.file_extension, false, true)

  if #files == 0 then
    H.notify("No sessions to prune")
    return
  end

  for _, f in ipairs(files) do
    vim.fn.delete(f)
  end

  H.notify("Pruned " .. #files .. " session" .. (#files == 1 and "" or "s"))
end

Session.list = function()
  local cfg = H.get_config()
  local files = vim.fn.glob(cfg.session_dir .. '/*' .. cfg.file_extension, false, true)

  if #files == 0 then
    H.notify("No saved sessions")
    return
  end

  local current_repo = H.get_repo_name()
  local lines = { "Saved sessions:" }
  for _, f in ipairs(files) do
    local name = vim.fn.fnamemodify(f, ':t:r')
    local marker = (name == current_repo) and " *" or ""
    table.insert(lines, "  " .. name .. marker)
  end

  H.notify(table.concat(lines, '\n'))
end

H.create_user_command = function()
  local cfg = H.get_config()
  local cmd = cfg.command_name

  pcall(vim.api.nvim_del_user_command, cmd)

  vim.api.nvim_create_user_command(cmd, function(opts)
    local action = opts.fargs[1]

    if Session[action] and type(Session[action]) == 'function' then
      Session[action]()
    else
      H.notify("Unknown action: " .. (action or ""), vim.log.levels.ERROR)
    end
  end, {
    nargs = 1,
    complete = function()
      return { "save", "load", "list", "delete", "prune" }
    end,
  })
end

return Session
