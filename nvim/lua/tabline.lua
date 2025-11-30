local Tabline = {}
local H = {}

Tabline.config = {
  show_modified = true,
  modified_indicator = '[+] ',
  show_navigation = true,
  navigation_left = '< ',
  navigation_right = ' >',
  special_files = { 'index', 'page', 'layout' },
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
  config = vim.tbl_deep_extend('force', vim.deepcopy(H.default_config), config or {})
  return config
end

H.apply_config = function(config)
  Tabline.config = config
end

H.get_config = function(local_override)
  return vim.tbl_deep_extend('force', Tabline.config, vim.b.tabline_config or {}, local_override or {})
end

H.format_path = function(path, config)
  local cwd = vim.fn.getcwd()
  local abs_path = vim.fn.fnamemodify(path, ':p')
  
  local rel_path = abs_path:sub(#cwd + 2)
  local parts = vim.split(rel_path, '/')
  
  if #parts == 0 then
    return vim.fn.fnamemodify(path, ':t')
  end
  
  local filename = parts[#parts]
  
  local is_special = false
  for _, special in ipairs(config.special_files) do
    if filename:match('^' .. special .. '%.') then
      is_special = true
      break
    end
  end
  
  local result = ''
  
  for i = 1, #parts - 1 do
    if is_special and i == #parts - 1 then
      result = result .. parts[i] .. '/'
    else
      result = result .. parts[i]:sub(1, 1) .. '/'
    end
  end
  
  result = result .. filename
  
  return result
end

Tabline.render = function()
  local config = H.get_config()
  local current = vim.fn.tabpagenr()
  local total = vim.fn.tabpagenr('$')
  local width = vim.o.columns
  
  local function estimate_tab_width(tab_idx)
    local bufnr = vim.fn.tabpagebuflist(tab_idx)[vim.fn.tabpagewinnr(tab_idx)]
    local path = vim.fn.bufname(bufnr)
    local modified = config.show_modified and vim.fn.getbufvar(bufnr, '&modified') == 1 and config.modified_indicator or ''
    
    if path == '' then
      return #modified + #'[No Name]' + 2
    else
      local name = H.format_path(path, config)
      return #modified + #name + 2
    end
  end
  
  local tabs_to_show = { current }
  local used_width = estimate_tab_width(current)
  local nav_space = 10
  local available = width - nav_space
  local left = current - 1
  local right = current + 1
  local add_right = true
  
  while (left >= 1 or right <= total) and used_width < available do
    if add_right and right <= total then
      local w = estimate_tab_width(right)
      if used_width + w > available then break end
      table.insert(tabs_to_show, right)
      used_width = used_width + w
      right = right + 1
    elseif left >= 1 then
      local w = estimate_tab_width(left)
      if used_width + w > available then break end
      table.insert(tabs_to_show, 1, left)
      used_width = used_width + w
      left = left - 1
    end
    add_right = not add_right
  end
  
  while right <= total and used_width < available do
    local w = estimate_tab_width(right)
    if used_width + w > available then break end
    table.insert(tabs_to_show, right)
    used_width = used_width + w
    right = right + 1
  end
  
  while left >= 1 and used_width < available do
    local w = estimate_tab_width(left)
    if used_width + w > available then break end
    table.insert(tabs_to_show, 1, left)
    used_width = used_width + w
    left = left - 1
  end
  
  local start_tab = tabs_to_show[1]
  local end_tab = tabs_to_show[#tabs_to_show]
  local hidden_left = start_tab - 1
  local hidden_right = total - end_tab
  local s = ''
  
  if config.show_navigation and hidden_left > 0 then
    s = s .. '%#TabLine#' .. config.navigation_left .. '(' .. hidden_left .. ') '
  end
  
  for i = start_tab, end_tab do
    s = s .. (i == current and '%#TabLineSel#' or '%#TabLine#')
    
    local bufnr = vim.fn.tabpagebuflist(i)[vim.fn.tabpagewinnr(i)]
    local path = vim.fn.bufname(bufnr)
    local modified = ''
    
    if config.show_modified and vim.fn.getbufvar(bufnr, '&modified') == 1 then
      modified = config.modified_indicator
    end
    
    if path == '' then
      s = s .. ' ' .. modified .. '[No Name] '
    else
      local name = H.format_path(path, config)
      s = s .. ' ' .. modified .. name .. ' '
    end
  end
  
  if config.show_navigation and hidden_right > 0 then
    s = s .. '%#TabLine# (' .. hidden_right .. ')' .. config.navigation_right
  end
  
  s = s .. '%#TabLineFill#'
  return s
end

return Tabline
