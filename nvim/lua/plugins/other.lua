require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.splitjoin").setup()
require("mini.comment").setup()
require("mini.surround").setup()
require("mini.extra").setup()

require("mini.pick").setup({
  options = {
    content_from_bottom = true,
  },
  mappings = {
    refine = "<C-e>",
  },
  window = {
    prompt_prefix = " ",
    config = function()
      return {
        anchor = "SW",
        height = math.floor(0.8 * vim.o.lines),
        width = vim.o.columns,
        row = vim.o.lines - 1,
        col = 0,
      }
    end,
  },
})

require("hardtime").setup()
