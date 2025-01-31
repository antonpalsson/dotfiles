require("mini.extra").setup()
require('mini.pick').setup({
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

-- Bindings
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
