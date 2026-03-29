return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    -- Configurar isort para Python (puedes añadir "black" después si quieres)
    opts.formatters_by_ft.python = { "isort", "black" }

    -- Mantener tu ajuste para fish
    opts.formatters_by_ft.fish = nil
  end,
}
