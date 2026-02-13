return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      local wk = require("which-key")
      wk.add({
        { "<leader>1", group = "Opencode", icon = "🔮", mode = { "n", "v" } },
        { "<leader>2", group = "Gemini", icon = "🔮", mode = { "n", "v" } },
        { "<leader>3", group = "Codex", icon = "🔮", mode = { "n", "v" } },
      })
    end,
  },
}
