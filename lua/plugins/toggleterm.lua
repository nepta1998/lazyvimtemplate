return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      -- Set terminal options here (e.g., direction = "float")
    },
    keys = {
      -- Example: Press <leader>tf to open a floating terminal
      { "<leader>4f", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle Floating Terminal" },
      -- Example: Press <leader>th to open a horizontal terminal
      { "<leader>4h", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Toggle Horizontal Terminal" },
      -- Example: Overwrite default toggle key (e.g., to <C-/>)
      { "<leader>4t", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
      { "<A-t>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = { "t" } },
    },
  },
}
