return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    require("mini.extra").setup({})
    require("mini.icons").setup({})
    require("mini.splitjoin").setup({})
    require("mini.surround").setup({})
    require("mini.pairs").setup({})
    -- require("mini.ai").setup()


    -- Pick --
    require("mini.pick").setup({
      options = {
        content_from_bottom = true,
      },
      window = {
        prompt_prefix = " ",
        config = function()
          return {
            anchor = "SW",
            height = math.min(vim.o.lines, 60),
            width = vim.o.columns,
            row = vim.o.lines - 1,
            col = 0,
          }
        end,
      },
    })

    vim.keymap.set("n", "<leader>ff", ":Pick files<CR>", {})
    vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>", {})
    vim.keymap.set("n", "<leader>fb", ":Pick buffers<CR>", {})
    vim.keymap.set("n", "<leader>fh", ":Pick git_hunks<CR>", {})
    vim.keymap.set("n", "<leader>fc", ":Pick git_commits<CR>", {})
    vim.keymap.set("n", "<leader>fe", ":Pick explorer<CR>", {})
    vim.keymap.set("n", "<leader>fd", ":Pick diagnostic<CR>", {})
    vim.keymap.set("n", "<leader>f:", ":Pick commands<CR>", {})
    vim.keymap.set("n", "<leader>fm", ":Pick marks<CR>", {})
    vim.keymap.set("n", "<leader>fo", ":Pick oldfiles<CR>", {})


    -- Diff --
    require("mini.diff").setup({
      view = {
        style = "sign",
        signs = { add = "+", change = "~", delete = "-" },
        priority = 9,
      }
    })

    vim.keymap.set("n", "<leader>lh", MiniDiff.toggle_overlay, {})
    -- gH reset


    -- Notify --
    require("mini.notify").setup({
      winblend = 100,
      window = {
        config = function()
          return {
            anchor = "SE",
            row = vim.o.lines - 2,
          }
        end,
      },
    })


    -- Statusline --
    local mini_statusline = require("mini.statusline")

    local function statusline()
      local mode, mode_hl = mini_statusline.section_mode({ trunc_width = 120 })
      local git           = mini_statusline.section_git({ trunc_width = 40 })
      local diff          = mini_statusline.section_diff({ trunc_width = 75 })
      local diagnostics   = mini_statusline.section_diagnostics({ trunc_width = 75 })
      local lsp           = mini_statusline.section_lsp({ icon = "λ", trunc_width = 75 })
      local filename      = mini_statusline.section_filename({ trunc_width = 9999 }) -- Always truncate
      local percent       = "%2p%%"
      local location      = "%3l:%-2c"

      return mini_statusline.combine_groups({
        { hl = mode_hl,                 strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFilename", strings = { "%{&filetype}" } },
        { hl = "MiniStatuslineFileinfo", strings = { percent } },
        { hl = mode_hl,                  strings = { location } },
      })
    end

    mini_statusline.setup({
      content = {
        active = statusline
      },
    })


    --- Starter --
    local mini_starter = require("mini.starter")

    mini_starter.setup({
      header = function()
        return [[
       //
     _oo\
    (__/ \  _  _
       \  \/ \/ \
       (         )\
        \_______/  \
         [[] [[]
         [[] [[]
      ]]
      end,
      items = {
        { action = ":enew | Ex", name = "Explore", section = "" },
        -- { action = ":source prev_session", name = "Previous session", section = "" },
        { action = ":enew",      name = "Buffer",  section = "" },
        { action = ":q",         name = "Quit",    section = "" },
      },
      footer = function()
        local version_info = vim.version()
        return string.format("nvim v%d.%d.%d", version_info.major, version_info.minor, version_info.patch)
      end
    })
  end
}
