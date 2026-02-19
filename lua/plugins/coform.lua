return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Eliminar fish_indent de la lista de formateadores disponibles
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.fish = nil
    end,
  },
}
