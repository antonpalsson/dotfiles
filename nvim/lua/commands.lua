if not vim.env.MINIMAL_NVIM then
  -- Auto resize splits
  vim.api.nvim_create_autocmd("VimResized", {
    command = "wincmd =",
  })

  -- Notify on macro recording
  vim.api.nvim_create_autocmd("RecordingEnter", {
    callback = function()
      vim.notify("Recording macro to register: " .. vim.fn.reg_recording(), vim.log.levels.WARN)
    end,
  })

  vim.api.nvim_create_autocmd("RecordingLeave", {
    callback = function()
      vim.notify("Macro recording stopped", vim.log.levels.INFO)
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
end
