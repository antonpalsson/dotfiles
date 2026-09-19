local Session = {}
local H = {}

Session.config = {
  session_dir     = vim.fn.stdpath("data") .. "/sessions",
  file_extension  = ".txt",
  auto_create_dir = true,
  auto_save       = false,
  auto_load       = false,
  notify          = true,
  notify_level    = vim.log.levels.INFO,
  command_name    = "Session",
}

H.default_config = vim.deepcopy(Session.config)

Session.setup = function(config)
  _G.Session = Session

  config = H.setup_config(config)
  H.apply_config(config)

  if config.auto_create_dir then
    vim.fn.mkdir(H.get_config().session_dir, "p")
  end

  if config.auto_save then
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = vim.api.nvim_create_augroup("SessionAutoSave", { clear = true }),
      callback = Session.save,
    })
  end

  if config.auto_load then
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("SessionAutoLoad", { clear = true }),
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
  H.check_type("config", config, "table", true)

  config = vim.tbl_deep_extend("force", H.default_config, config or {})

  H.check_type("session_dir", config.session_dir, "string")
  H.check_type("file_extension", config.file_extension, "string")
  H.check_type("auto_create_dir", config.auto_create_dir, "boolean")
  H.check_type("auto_save", config.auto_save, "boolean")
  H.check_type("auto_load", config.auto_load, "boolean")
  H.check_type("notify", config.notify, "boolean")
  H.check_type("notify_level", config.notify_level, "number")
  H.check_type("command_name", config.command_name, "string")

  return config
end

H.apply_config = function(config) Session.config = config end

H.get_config = function()
  return vim.tbl_deep_extend("force", Session.config, vim.b.session_config or {})
end

H.get_repo_info = function()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")

  if not handle then return nil, nil end

  local path = handle:read("*l")
  handle:close()

  if not path or path == "" then return nil, nil end

  return vim.fn.fnamemodify(path, ":t"), path
end

H.get_repo_name = function()
  local name = H.get_repo_info()
  return name
end

H.get_session_path = function()
  local cfg = H.get_config()
  local repo = H.get_repo_name()

  if not repo then return nil, nil, "Not in a git repository" end

  local path = cfg.session_dir .. "/" .. repo .. cfg.file_extension

  return path, repo, nil
end

H.notify = function(msg, level)
  local cfg = H.get_config()

  if not cfg.notify then return end

  vim.notify(msg, level or cfg.notify_level)
end

H.check_type = function(name, val, ref, allow_nil)
  if (allow_nil and val == nil) or type(val) == ref then return end

  error(string.format("(session) `%s` should be %s, not %s", name, ref, type(val)), 0)
end

H.get_open_files = function()
  local seen = {}
  local files = {}
  local current_buf = vim.api.nvim_get_current_buf()

  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if not seen[buf] then
        local path = vim.api.nvim_buf_get_name(buf)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
        if path ~= "" and buftype == "" then
          local cursor = vim.api.nvim_win_get_cursor(win)
          table.insert(files, { path = path, line = cursor[1], col = cursor[2], current = buf == current_buf })
          seen[buf] = true
        end
      end
    end
  end

  return files
end

H.write_session = function(path, entries)
  local file = io.open(path, "w")
  if not file then return false end

  for _, entry in ipairs(entries) do
    file:write((entry.current and "*" or "") .. entry.path .. ":" .. entry.line .. ":" .. entry.col .. "\n")
  end
  file:close()

  return true
end

H.clamp_cursor = function(buf, line, col)
  line = math.min(math.max(line or 1, 1), vim.api.nvim_buf_line_count(buf))

  local text = vim.api.nvim_buf_get_lines(buf, line - 1, line, false)[1] or ""
  col = math.min(math.max(col or 0, 0), #text)

  return line, col
end

Session.save = function()
  local path, repo, err = H.get_session_path()

  if not path or not repo then
    H.notify("Session save failed: " .. (err or "unknown"), vim.log.levels.ERROR)
    return
  end

  local files = H.get_open_files()

  if #files == 0 then
    H.notify("No open files to save", vim.log.levels.WARN)
    return
  end

  if not H.write_session(path, files) then
    H.notify("Session save failed: could not write to " .. path, vim.log.levels.ERROR)
    return
  end

  local summary = { "Session saved: " .. repo }
  for _, entry in ipairs(files) do
    table.insert(summary, "  " .. vim.fn.fnamemodify(entry.path, ":.") .. ":" .. entry.line .. ":" .. entry.col)
  end
  H.notify(table.concat(summary, "\n"))
end

Session.load = function()
  local path, repo, err = H.get_session_path()

  if not path or not repo then
    H.notify("Session load failed: " .. (err or "unknown"), vim.log.levels.ERROR)
    return
  end

  local _, root = H.get_repo_info()
  if root then vim.cmd("cd " .. vim.fn.fnameescape(root)) end

  if vim.fn.filereadable(path) == 0 then
    H.notify("No session found for: " .. repo, vim.log.levels.WARN)
    return
  end

  local file = io.open(path, "r")
  if not file then
    H.notify("Session load failed: could not read " .. path, vim.log.levels.ERROR)
    return
  end

  local entries = {}
  for line in file:lines() do
    local current = line:sub(1, 1) == "*"
    if current then line = line:sub(2) end

    local fpath, lnum, cnum = line:match("^(.+):(%d+):(%d+)$")
    if not fpath then fpath, lnum = line:match("^(.+):(%d+)$") end
    if not fpath and line ~= "" then fpath = line end

    if fpath then
      table.insert(entries, { path = fpath, line = tonumber(lnum) or 1, col = tonumber(cnum) or 0, current = current })
    end
  end
  file:close()

  if #entries == 0 then
    H.notify("Session is empty: " .. repo, vim.log.levels.WARN)
    return
  end

  local present, dropped = {}, 0
  for _, entry in ipairs(entries) do
    if vim.fn.filereadable(entry.path) == 1 then
      table.insert(present, entry)
    else
      dropped = dropped + 1
    end
  end

  if dropped > 0 then H.write_session(path, present) end

  if #present == 0 then
    H.notify("Session has no existing files: " .. repo, vim.log.levels.WARN)
    return
  end

  local current_tab = 1
  for i, entry in ipairs(present) do
    if i > 1 then vim.cmd("tabnew") end
    if entry.current then current_tab = i end
    vim.cmd("edit " .. vim.fn.fnameescape(entry.path))
    local line, col = H.clamp_cursor(0, entry.line, entry.col)
    vim.api.nvim_win_set_cursor(0, { line, col })
  end

  vim.cmd("tabnext " .. current_tab)

  local msg = "Session loaded: " .. repo
  if dropped > 0 then
    msg = msg .. " (dropped " .. dropped .. " missing file" .. (dropped == 1 and "" or "s") .. ")"
  end
  H.notify(msg)
end

Session.delete = function()
  local path, repo, err = H.get_session_path()

  if not path or not repo then
    H.notify("Session delete failed: " .. (err or "unknown"), vim.log.levels.ERROR)
    return
  end

  if vim.fn.filereadable(path) == 0 then
    H.notify("No session found for: " .. repo, vim.log.levels.WARN)
    return
  end

  vim.fn.delete(path)
  H.notify("Session deleted: " .. repo)
end

Session.purge = function()
  local cfg = H.get_config()
  local files = vim.fn.glob(cfg.session_dir .. "/*" .. cfg.file_extension, false, true)

  if #files == 0 then
    H.notify("No sessions to purge")
    return
  end

  for _, f in ipairs(files) do
    vim.fn.delete(f)
  end

  H.notify("Purged " .. #files .. " session" .. (#files == 1 and "" or "s"))
end

Session.list = function()
  local cfg = H.get_config()
  local files = vim.fn.glob(cfg.session_dir .. "/*" .. cfg.file_extension, false, true)

  if #files == 0 then
    H.notify("No saved sessions")
    return
  end

  local current_repo = H.get_repo_name()
  local lines = { "Saved sessions:" }
  for _, f in ipairs(files) do
    local name = vim.fn.fnamemodify(f, ":t:r")
    local marker = (name == current_repo) and " *" or ""
    table.insert(lines, "  " .. name .. marker)
  end

  H.notify(table.concat(lines, "\n"))
end

H.create_user_command = function()
  local cfg = H.get_config()
  local cmd = cfg.command_name

  pcall(vim.api.nvim_del_user_command, cmd)

  vim.api.nvim_create_user_command(cmd, function(opts)
    local action = opts.fargs[1]

    if Session[action] and type(Session[action]) == "function" then
      Session[action]()
    else
      H.notify("Unknown action: " .. (action or ""), vim.log.levels.ERROR)
    end
  end, {
    nargs = 1,
    complete = function()
      return { "save", "load", "list", "delete", "purge" }
    end,
  })
end

return Session
