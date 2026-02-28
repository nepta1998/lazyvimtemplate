return {
  "saghen/blink.cmp",
  dependencies = {
    "giuxtaposition/blink-cmp-copilot",
    "folke/sidekick.nvim", -- Añadido como dependencia para asegurar carga
  },
  opts = {
    keymap = {
      ["<Tab>"] = {
        function(cmp)
          -- 1. Intentar aplicar la sugerencia de Sidekick primero
          if require("sidekick").nes_jump_or_apply() then
            return true
          end
        end,
        "snippet_forward", -- 2. Si no hay Sidekick, avanzar snippet
        "fallback", -- 3. Si no, Tab normal
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 100,
          async = true,
        },
      },
    },
  },
}
