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
          -- 1. PRIORIDAD MÁXIMA: Sidekick (Saltos de IA / Aplicar cambios)
          -- Si Sidekick tiene un lugar a donde saltar, lo hace y detiene el proceso.
          if require("sidekick").nes_jump_or_apply() then
            return true
          end

          -- 2. SUGERENCIA DE COPILOT: Si hay "Ghost Text" visible, aceptarlo.
          -- (Recuerda que esto solo funciona si en copilot.lua tienes suggestion = { enabled = true })
          -- if require("copilot.suggestion").is_visible() then
          --   require("copilot.suggestion").accept()
          --   return true
          -- end

          -- 3. MENÚ DE AUTOCOMPLETADO: Si el menú está abierto, navegar al siguiente.
          if cmp.is_visible() then
            return cmp.select_next()
          end

          -- 4. FALLBACK: Si nada de lo anterior aplica, retornar false
          -- para que Blink intente 'snippet_forward' y luego 'fallback' (Tab normal).
          return false
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp)
          -- 1. Si el menú de autocompletado está abierto, ir al anterior
          if cmp.is_visible() then
            return cmp.select_prev()
          end

          -- 2. Si no hay menú, intentamos retroceder en un snippet
          -- Retornamos false para que pase a 'snippet_backward'
          return false
        end,
        "snippet_backward", -- 3. Si hay snippet activo, salta hacia atrás
        "fallback", -- 4. Si no, hace un outdent normal
      },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot", -- ¡ESTO ES NECESARIO!
          score_offset = 100,
          async = true,
          transform_items = function(_, items)
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            for _, item in ipairs(items) do
              item.kind = CompletionItemKind.Copilot
            end
            return items
          end,
        },
      },
    },
  },
}
