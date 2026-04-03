return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Insertamos al principio de lualine_x para que esté a la izquierda de la batería/porcentaje
      table.insert(opts.sections.lualine_x, 1, {
        function()
          local ok, api = pcall(require, "supermaven-nvim.api")
          if ok and api.is_running() then
            return "⚡"
          end
          return ""
        end,
        color = { fg = "#6ab0f3" },
        -- Estas 3 líneas son críticas para eliminar los <<< >>>
        -- separator = "",
        -- component_separators = { left = "", right = "" },
        -- padding = { left = 1, right = 0 },
      })
    end,
  },
}
