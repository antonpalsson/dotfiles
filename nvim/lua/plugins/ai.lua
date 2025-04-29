return {
  {
    "github/copilot.vim",
    config = function()
      vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
      vim.keymap.set("i", "<C-K>", "<Plug>(copilot-accept-word)")
      vim.g.copilot_no_tab_map = true
    end,
  },
  {
    "David-Kunz/gen.nvim",
    config = function()
      local gen = require("gen")

      gen.setup({
        model = "qwen3:14b",
        display_mode = "vertical-split",
        show_prompt = "full",
        no_auto_close = true,
        init = function(_)
          local check = io.popen("lsof -i :11434")
          local result = check:read("*a")
          check:close()

          if result == "" then
            pcall(os.execute, "ollama serve > /dev/null 2>&1 &")
          end
        end
      })

      gen.prompts = {
        plain = { prompt = "$input" },
        context = { prompt = "```$filetype\n$text\n```\n\n$input" },
      }

      vim.keymap.set("n", "<leader>gen", ":Gen plain<CR>")
      vim.keymap.set("v", "<leader>gen", ":Gen context<CR>")
      vim.keymap.set("n", "<leader>ges", function()
        require("gen").select_model()
      end)

      vim.keymap.set("n", "<leader>gek", function()
        local handle = io.popen("lsof -i :11434 -t")
        local pid = handle:read("*a")
        handle:close()

        pid = pid:match("^%s*(%d+)%s*$")

        if pid then
          os.execute("kill " .. pid)
          print("Ollama server killed")
          return true
        else
          print("Ollama server not running")
          return false
        end
      end)
    end
  }
}
