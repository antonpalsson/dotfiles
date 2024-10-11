-- Telescope

local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

telescope.setup({
	defaults = {
		layout_config = {
			height = 0.999,
			width = 0.999,
		},
		borderchars = { "─", "│", "─", "│", "┬", "┐", "┘", "┴" },
		mappings = {
			i = {
				-- Open all selected in new tabs
				["<C-o>"] = function(p_bufnr)
					actions.send_selected_to_qflist(p_bufnr)

					vim.cmd([[
            let qflist = getqflist()
            for i in range(len(qflist))
              execute 'tabedit ' . bufname(qflist[i].bufnr)
            endfor
          ]])
				end,
			},
			n = {
				-- History
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,
			},
		},
	},
	pickers = {
		find_files = {
			find_command = { "rg", "--hidden", "--files", "-g", "!.git/**", "-g", "!**/cache/**", "-g", "!.yarn/**" },
		},
		live_grep = {
			additional_args = { "--hidden", "-g", "!.git/**", "-g", "!.yarn/**" },
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
		},
	},
})

telescope.load_extension("fzf")

-- Show line numbers in preview window
vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")

-- Bindings
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fs", builtin.git_status, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fq", builtin.quickfix, {})

vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, {})
vim.keymap.set("n", "<leader>gr", builtin.lsp_references, {})
vim.keymap.set("n", "<leader>gi", builtin.lsp_implementations, {})
