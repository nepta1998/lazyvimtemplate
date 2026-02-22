return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      -- Set terminal options here (e.g., direction = "float")
    },
    keys = {
      -- Example: Press <leader>tf to open a floating terminal
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle Floating Terminal" },
      -- Example: Press <leader>th to open a horizontal terminal
      { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Toggle Horizontal Terminal" },
      -- Example: Overwrite default toggle key (e.g., to <C-/>)
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
      { "<A-t>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = { "t" } },
    },
  },
}
