return {
  "rhart92/codex.nvim",
  opts = {
    split = "vertical",
    size = 0.4,
    float = {
      width = 0.6,
      height = 0.6,
      border = "rounded",
      row = nil,
      col = nil,
      title = "Codex",
    },
    codex_cmd = { "codex" },
    focus_after_send = true,
    log_level = "warn",
    autostart = false,
  },
  keys = {
    {
      "<leader>3t",
      function()
        require("codex").toggle()
      end,
      desc = "Codex: Toggle",
    },
    {
      "<leader>3a",
      function()
        require("codex").actions.send_selection()
      end,
      desc = "Codex: Send selection",
      mode = { "v" },
    },
    {
      "<C-t>",
      function()
        require("codex").toggle()
      end,
      desc = "Codex: Toggle",
      mode = { "t" },
    },
  },
}
