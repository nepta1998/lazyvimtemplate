return {
  {
    "folke/which-key.nvim",

    event = "VeryLazy", -- Load this plugin on the 'VeryLazy' event

    init = function()
      -- Set the timeout for key sequences
      vim.o.timeout = true
      vim.o.timeoutlen = 300 -- Set the timeout length to 300 milliseconds
    end,

    opts = function(_, opts)
      local wk = require("which-key")
      wk.add({

        {
          -- Keybinding to show which-key popup
          "<leader>?",
          function()
            require("which-key").show({ global = false }) -- Show the which-key popup for local keybindings
          end,
          desc = "Show which-key",
        },
        { "<leader>1", group = "Opencode", icon = "🔮", mode = { "n", "v" } },
        { "<leader>2", group = "Gemini", icon = "🔮", mode = { "n", "v" } },
        { "<leader>3", group = "Codex", icon = "🔮", mode = { "n", "v" } },
        { "<leader>t", group = "Terminal", icon = "📜", mode = { "n", "v" } },
        { "<leader>4", group = "Test", icon = "🧪" },
      })
    end,
  },
}
