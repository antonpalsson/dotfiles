-- Mini

require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.splitjoin").setup()
require("mini.surround").setup()
require("mini.extra").setup()


-- Pick
local win_conf = function()
	return {
		anchor = "SW",
		height = math.floor(0.8 * vim.o.lines),
		width = vim.o.columns,
		row = vim.o.lines,
		col = 0,
	}
end

require("mini.pick").setup({
	options = {
		content_from_bottom = true,
	},
	window = {
		config = win_conf,
	},
})


-- Complete
require("mini.completion").setup()

-- Navigate complete menu with TAB
local imap_expr = function(lhs, rhs)
	vim.keymap.set("i", lhs, rhs, { expr = true })
end

imap_expr("<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
imap_expr("<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

-- Normal CR when complete menu is visible
local keycode = vim.keycode or function(x)
	return vim.api.nvim_replace_termcodes(x, true, true, true)
end

local keys = {
	["cr"] = keycode("<CR>"),
	["ctrl-y"] = keycode("<C-y>"),
	["ctrl-y_cr"] = keycode("<C-y><CR>"),
}

_G.cr_action = function()
	if vim.fn.pumvisible() ~= 0 then
		local item_selected = vim.fn.complete_info()["selected"] ~= -1
		return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
	else
		return keys["cr"]
	end
end

vim.keymap.set("i", "<CR>", "v:lua._G.cr_action()", { expr = true })
