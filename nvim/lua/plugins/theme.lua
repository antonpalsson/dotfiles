return {
  "vague2k/vague.nvim",
  config = function()
    require("vague").setup({
      transparent = true
    })

    vim.cmd.colorscheme("vague")

    local c = require("vague.config.internal").current.colors
    local c_trans = "#04080D"

    vim.api.nvim_set_hl(0, "TabLine", { fg = c.fg })
    vim.api.nvim_set_hl(0, "TabLineSel", { fg = "white", bg = "#4A4A4A", bold = true })
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = c_trans })

    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1A1A1A" })

    vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#1A1A1A" })
    vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#3A3A3A" })

    vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = "white", bg = "#4A4A4A" })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = c.bg, bg = c.builtin })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = c.bg, bg = c.delta })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = c.bg, bg = c.plus })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = c.bg, bg = c.hint })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", { fg = c.bg, bg = c.hint })
    vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = c.fg, bg = "#2A2A2A" })
    vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = c.fg, bg = c_trans })
    vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = c.fg, bg = "#2A2A2A" })
  end,
}
