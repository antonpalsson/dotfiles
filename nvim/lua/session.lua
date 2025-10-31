local Session = {}
local H = {}

Session.config = {
  session_dir     = vim.fn.stdpath('data') .. '/sessions',
  file_extension  = '.vim',
  auto_create_dir = true,
  notify          = true,
  notify_level    = vim.log.levels.INFO,
  command_name    = 'Session',
  allow_prune     = true,
}

H.default_config = vim.deepcopy(Session.config)

Session.setup = function(config)
  _G.Session = Session

  config = H.setup_config(config)
  H.apply_config(config)

  if config.auto_create_dir then
    vim.fn.mkdir(H.get_session_dir(), 'p')
  end

  H.create_user_command()
end

H.setup_config = function(config)
  H.check_type('config', config, 'table', true)

  config = vim.tbl_deep_extend('force', vim.deepcopy(H.default_config), config or {})

  H.check_type('session_dir', config.session_dir, 'string')
  H.check_type('file_extension', config.file_extension, 'string')
  H.check_type('auto_create_dir', config.auto_create_dir, 'boolean')
  H.check_type('notify', config.notify, 'boolean')
  H.check_type('notify_level', config.notify_level, 'number')
  H.check_type('command_name', config.command_name, 'string')
  H.check_type('allow_prune', config.allow_prune, 'boolean')

  return config
end

H.apply_config = function(config) Session.config = config end

H.get_config = function(local_override)
  return vim.tbl_deep_extend('force', Session.config, vim.b.session_config or {}, local_override or {})
end

H.get_session_dir = function()
  return H.get_config().session_dir
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


Session.save = function()
  local path, repo, err = H.get_session_path()

  if not path or not repo then
    H.notify("Session save failed: " .. (err or 'unknown'), vim.log.levels.ERROR)
    return
  end

  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), 'p')
  vim.cmd("mks! " .. vim.fn.fnameescape(path))
  H.notify("Session saved: " .. repo)
end

Session.load = function()
  local path, repo, err = H.get_session_path()

  if not path or not repo then
    H.notify("Session load failed: " .. (err or 'unknown'), vim.log.levels.ERROR)
    return
  end

  if vim.fn.filereadable(path) == 0 then
    H.notify("No session file found for this repo", vim.log.levels.WARN)
    return
  end

  vim.cmd("source " .. vim.fn.fnameescape(path))
  H.notify("Session loaded: " .. repo)
end

Session.delete = function()
  local path, _, err = H.get_session_path()

  if not path then
    H.notify("Session delete failed: " .. (err or 'unknown'), vim.log.levels.ERROR)
    return
  end

  if vim.fn.delete(path) == 0 then
    H.notify("Deleted session for current repo")
  else
    H.notify("No session file to delete", vim.log.levels.WARN)
  end
end

Session.list = function()
  local dir = H.get_session_dir()
  local glob_pat = dir .. '/*' .. H.get_config().file_extension
  local sessions = vim.fn.glob(glob_pat, false, true)

  if #sessions == 0 then
    H.notify("No saved sessions", vim.log.levels.INFO)
    return
  end

  local current = H.get_repo_name()
  local lines = { "Saved sessions:" }

  for _, p in ipairs(sessions) do
    local name = vim.fn.fnamemodify(p, ":t:r")
    local marker = (name == current) and "*" or " "
    table.insert(lines, string.format(" %s %s", marker, name))
  end

  H.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

Session.prune = function()
  local dir = H.get_session_dir()
  vim.fn.delete(dir, "rf")
  vim.fn.mkdir(dir, "p")
  H.notify("All sessions pruned")
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
      local items = { "save", "load", "delete", "prune", "list" }
      return items
    end,
  })
end

return Session
