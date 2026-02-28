return {
  "saghen/blink.cmp",
  dependencies = {
    "giuxtaposition/blink-cmp-copilot", -- ESTO ES LO QUE TE FALTA
  },
  opts = {
    -- ... tu configuración existente
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
