local Tabline = {}
local H = {}

local default_config = {
  show_modified = true,
  modified_indicator = '[+] ',
  show_navigation = true,
  navigation_left = '< ',
  navigation_right = ' >',
  special_files = {
    'index', 'init', '__init__', 'main', 'app', 'config', 'types', 'utils',
    'routes', 'settings', 'page', 'layout', 'component', 'style', 'styles',
    'store', 'actions', 'views', 'models', 'hooks', 'middleware', 'context',
    'helpers', 'constants', 'api', 'lib', 'application', 'schema', 'urls',
    'forms', 'admin', 'base', 'server', 'client', 'reducers', 'selectors',
    'queries', 'mutations', 'providers', 'serializers', 'seeds', 'conftest',
    'loading', 'error', 'not-found', 'template', 'head',
  },
}

Tabline.config = vim.deepcopy(default_config)

Tabline.setup = function(config)
  _G.Tabline = Tabline
  vim.validate({ config = { config, 'table', true } })
  Tabline.config = vim.tbl_deep_extend('force', vim.deepcopy(default_config), config or {})
  vim.o.tabline = '%!v:lua.Tabline.render()'
end

H.format_path = function(bufnr, config)
  local path = vim.api.nvim_buf_get_name(bufnr)

  if path == '' then return '[Empty]' end

  local rel_path = vim.fn.fnamemodify(path, ':.')

  if rel_path == path then
    return vim.fn.fnamemodify(path, ':t')
  end

  local parts = vim.split(rel_path, '/')
  local n = #parts
  if n == 1 then return parts[1] end

  local filename = parts[n]
  local file_stem = vim.fn.fnamemodify(filename, ':r')
  local is_special = vim.tbl_contains(config.special_files, file_stem)

  local result_parts = {}
  for i = 1, n - 1 do
    local part = parts[i]
    if is_special and i == n - 1 then
      table.insert(result_parts, part)
    else
      table.insert(result_parts, part:sub(1, 2))
    end
  end
  table.insert(result_parts, filename)

  return table.concat(result_parts, '/')
end

Tabline.render = function()
  local config = Tabline.config
  local current = vim.fn.tabpagenr()
  local total = vim.fn.tabpagenr('$')
  local width = vim.o.columns

  local tabs = {}
  for i = 1, total do
    local winnr = vim.fn.tabpagewinnr(i)
    local buflist = vim.fn.tabpagebuflist(i)
    local bufnr = buflist[winnr]
    local name = H.format_path(bufnr, config)
    local modified = (config.show_modified and vim.fn.getbufvar(bufnr, '&modified') == 1)
        and config.modified_indicator or ''
    local label = ' ' .. modified .. name .. ' '
    tabs[i] = { label = label, len = #label }
  end

  local total_tabs_width = 0
  for i = 1, total do total_tabs_width = total_tabs_width + tabs[i].len end

  -- Reserve 12 columns for navigation arrows
  local available = width - 12
  local is_overflowing = total_tabs_width > available

  local start_tab, end_tab = 1, total
  if is_overflowing then
    local used = tabs[current].len
    start_tab = current
    end_tab = current

    while true do
      local expanded = false
      if start_tab > 1 and (used + tabs[start_tab - 1].len < available) then
        start_tab = start_tab - 1
        used = used + tabs[start_tab].len
        expanded = true
      end
      if end_tab < total and (used + tabs[end_tab + 1].len < available) then
        end_tab = end_tab + 1
        used = used + tabs[end_tab].len
        expanded = true
      end
      if not expanded then break end
    end
  end

  local s = ''

  if config.show_navigation and start_tab > 1 then
    s = s .. '%#TabLine# ' .. config.navigation_left .. ' '
  end

  for i = start_tab, end_tab do
    s = s .. (i == current and '%#TabLineSel#' or '%#TabLine#')
    s = s .. '%' .. i .. 'T'
    s = s .. tabs[i].label
  end

  s = s .. '%#TabLineFill#%T'

  if config.show_navigation and end_tab < total then
    -- %= pushes the right navigation arrow to the far right
    s = s .. '%=%#TabLine# ' .. config.navigation_right .. ' '
  end

  return s
end

return Tabline
