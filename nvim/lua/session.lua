local M = {}

local session_dir = vim.fn.stdpath('data') .. '/sessions/'
vim.fn.mkdir(session_dir, 'p')

local function get_repo_name()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")

  if not handle then return nil end

  local path = handle:read("*l")
  handle:close()

  if not path then return nil end

  return vim.fn.fnamemodify(path, ":t")
end

local function get_session_path()
  local repo = get_repo_name()

  if not repo then return nil, nil, "Not in a git repository" end

  return session_dir .. repo .. ".vim", repo, nil
end

function M.save()
  local path, repo, err = get_session_path()

  if not path or not repo then
    vim.notify("Session save failed: " .. err, vim.log.levels.ERROR)
    return
  end

  vim.cmd("mks! " .. vim.fn.fnameescape(path))
  vim.notify("Session saved for repo: " .. repo)
end

function M.load()
  local path, repo, err = get_session_path()

  if not path or not repo then
    vim.notify("Session load failed: " .. err, vim.log.levels.ERROR)
    return
  end

  if vim.fn.filereadable(path) == 0 then
    vim.notify("No session file found for this repo", vim.log.levels.WARN)
    return
  end

  vim.cmd("source " .. vim.fn.fnameescape(path))
  vim.notify("Session loaded: " .. repo)
end

function M.delete()
  local path, _, err = get_session_path()

  if not path then
    vim.notify("Session delete failed: " .. err, vim.log.levels.ERROR)
    return
  end

  if vim.fn.delete(path) == 0 then
    vim.notify("Deleted session for current repo")
  else
    vim.notify("No session file found to delete", vim.log.levels.WARN)
  end
end

function M.list()
  local sessions = vim.fn.glob(session_dir .. "*.vim", false, true)

  if #sessions == 0 then
    vim.notify("No saved sessions found", vim.log.levels.INFO)
    return
  end

  local lines = { "Saved sessions:" }
  local current_repo = get_repo_name()

  for _, session_path in ipairs(sessions) do
    local session_name = vim.fn.fnamemodify(session_path, ":t:r")
    local marker = (session_name == current_repo) and " *" or ""
    table.insert(lines, "  " .. session_name .. marker)
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

function M.prune()
  vim.fn.delete(session_dir, "rf")
  vim.fn.mkdir(session_dir, "p")
  vim.notify("All sessions pruned")
end

vim.api.nvim_create_user_command("Session", function(opts)
  local action = opts.fargs[1]

  if M[action] then
    M[action]()
  else
    vim.notify("Unknown action: " .. (action or ""), vim.log.levels.ERROR)
  end
end, { nargs = 1, complete = function() return { "save", "load", "delete", "prune", "list" } end })

return M
