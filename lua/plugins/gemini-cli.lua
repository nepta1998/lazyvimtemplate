return {
  "marcinjahn/gemini-cli.nvim",
  cmd = "Gemini",
  -- Example key mappings for common actions:
  keys = {
    { "<leader>2t", "<cmd>Gemini toggle<cr>", desc = "Toggle Gemini CLI" },
    { "<leader>2a", "<cmd>Gemini ask<cr>", desc = "Ask Gemini", mode = { "n", "v" } },
    { "<leader>2f", "<cmd>Gemini add_file<cr>", desc = "Add File" },
    { "<C-f>", "<cmd>Gemini toggle<cr>", desc = "Toggle Gemini CLI", mode = { "t" } },
  },
  dependencies = {
    "folke/snacks.nvim",
  },
  config = true,
}
