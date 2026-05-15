return {
  "folke/sidekick.nvim",
  opts = {
    nes = {
      enabled = false, -- Esto desactiva las sugerencias de edición en el texto
    },
    cli = {
      win = {
        keys = {
          prompt = { "<c-o>", "prompt", mode = "t", desc = "insert prompt or context" },
        },
      },
      mux = {
        enabled = true,
        backend = "tmux", -- or "zellij"
      },
      tools = {
        kilo = {
          cmd = { "kilo" },
          -- keys = {
          --   submit = {
          --     "<c-s>",
          --     function(t)
          --       t:send("\n")
          --     end,
          --   },
          -- },
        },
      },
    },
  },
}
