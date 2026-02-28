return {
  "saghen/blink.cmp",
  dependencies = {
    "giuxtaposition/blink-cmp-copilot", -- ESTO ES LO QUE TE FALTA
  },
  opts = {
    -- ... tu configuración existente
    menu = {
      auto_show = true, -- El menú seguirá apareciendo
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot", -- Ahora sí encontrará el módulo
          score_offset = 100,
          async = true,
        },
      },
    },
  },
}
