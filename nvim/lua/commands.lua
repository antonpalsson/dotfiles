-- Treesitter
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Auto resize splits
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})

-- Notify on macro recording
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    vim.notify("Recording macro to register: " .. vim.fn.reg_recording(), vim.log.levels.WARN, { id = "macro_mode", timeout = false })
  end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    Snacks.notifier.hide("macro_mode")
  end,
})

-- Notifier for LSP progress
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(vim.lsp.status(), "info", {
      id = "lsp_progress",
      title = "LSP Progress",
      opts = function(notif)
        notif.icon = ev.data.params.value.kind == "end" and " "
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

-- Close Snacks explorer together with the last window
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local explorer = Snacks.picker.get({ source = "explorer" })[1]
    if not explorer then
      return
    end

    local tab_wins = vim.api.nvim_tabpage_list_wins(0)
    local explorer_wins = {}
    for _, w in pairs(explorer.layout:get_wins()) do
      if w:win_valid() and vim.tbl_contains(tab_wins, w.win) then
        explorer_wins[w.win] = true
      end
    end
    if vim.tbl_isempty(explorer_wins) then
      return
    end

    local others = vim.tbl_filter(function(win)
      return not explorer_wins[win] and vim.api.nvim_win_get_config(win).relative == ""
    end, tab_wins)
    if #others ~= 1 then
      return
    end

    local in_explorer = explorer_wins[vim.api.nvim_get_current_win()]
    explorer:close()
    for win in pairs(explorer_wins) do
      pcall(vim.api.nvim_win_close, win, true)
    end

    if in_explorer then
      vim.schedule(function()
        vim.api.nvim_set_current_win(others[1])
        local ok, err = pcall(vim.cmd.quit)
        if not ok then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end)
    end
  end,
})

-- Post-update hooks
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= "update" and kind ~= "install" then
      return
    end

    if name == "nvim-treesitter" then
      require("nvim-treesitter").update()
    end

    if name == "blink.cmp" then
      require("blink.cmp").build()
    end
  end,
})

vim.api.nvim_create_user_command("Update", function(opts)
  vim.pack.update(nil, { force = opts.bang })
end, { bang = true, desc = "Update plugins, treesitter parsers and blink's fuzzy matcher" })

vim.api.nvim_create_user_command("BufDeleteAll", function()
  vim.cmd("%bdelete!")
  vim.notify("Deleted all buffers")
end, { desc = "Delete all buffers" })
