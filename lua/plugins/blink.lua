return {
  "saghen/blink.cmp",
  dependencies = { "giuxtaposition/blink-cmp-copilot" },
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 100, -- Ajusta la prioridad (más alto = más arriba en la lista)
          async = true,
        },
      },
    },
  },
}
