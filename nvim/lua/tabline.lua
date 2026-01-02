local Tabline = {}
local H = {}

Tabline.config = {
  show_modified = true,
  modified_indicator = '[+] ',
  show_navigation = true,
  navigation_left = '< ',
  navigation_right = ' >',
  special_files = {
    'index', 'page', 'layout', 'init', 'style', 'styles', 'component', 'main'
  },
}

H.default_config = vim.deepcopy(Tabline.config)

Tabline.setup = function(config)
  _G.Tabline = Tabline
  config = H.setup_config(config)
  H.apply_config(config)
  vim.o.tabline = '%!v:lua.Tabline.render()'
end

H.setup_config = function(config)
  vim.validate({ config = { config, 'table', true } })
  return vim.tbl_deep_extend('force', vim.deepcopy(H.default_config), config or {})
end

H.apply_config = function(config)
  Tabline.config = config
end

H.get_config = function()
  return Tabline.config
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

  local is_special = false
  for _, special in ipairs(config.special_files) do
    if file_stem == special then
      is_special = true
      break
    end
  end

  local result_parts = {}
  for i = 1, n - 1 do
    local part = parts[i]
    if is_special and i == n - 1 then
      table.insert(result_parts, part)
    else
      local truncated = part:sub(1, part:sub(1, 1) == '.' and 2 or 1)
      table.insert(result_parts, truncated)
    end
  end
  table.insert(result_parts, filename)

  return table.concat(result_parts, '/')
end

Tabline.render = function()
  local config = H.get_config()
  local current = vim.fn.tabpagenr()
  local total = vim.fn.tabpagenr('$')
  local width = vim.o.columns

  local tabs = {}
  local total_tabs_width = 0

  for i = 1, total do
    local winnr = vim.fn.tabpagewinnr(i)
    local buflist = vim.fn.tabpagebuflist(i)
    local bufnr = buflist[winnr]
    local name = H.format_path(bufnr, config)
    local modified = (config.show_modified and vim.fn.getbufvar(bufnr, '&modified') == 1)
        and config.modified_indicator or ''
    local label = ' ' .. modified .. name .. ' '

    tabs[i] = { label = label, len = #label }
    total_tabs_width = total_tabs_width + #label
  end

  local is_overflowing = total_tabs_width > (width - 10)

  local start_tab, end_tab = 1, total
  if is_overflowing then
    local available = width - 12
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
    if i == current then
      s = s .. '%#TabLineSel#'
    else
      s = s .. '%#TabLine#'
    end
    s = s .. '%' .. i .. 'T'
    s = s .. tabs[i].label
  end

  s = s .. '%#TabLineFill#%T'

  if config.show_navigation and end_tab < total then
    s = s .. '%=' .. '%#TabLine# ' .. config.navigation_right .. ' '
  end

  return s
end

return Tabline
