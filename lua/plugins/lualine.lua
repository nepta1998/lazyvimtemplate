return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.component_separators = { left = "", right = "" }
      opts.options.section_separators = { left = "", right = "" }

      -- 3. Insertamos tu componente de Supermaven (el rayo)
      table.insert(opts.sections.lualine_x, 1, {
        function()
          local ok, api = pcall(require, "supermaven-nvim.api")
          if ok and api.is_running() then
            return "⚡"
          end
          return ""
        end,
        color = { fg = "#6ab0f3" },
        padding = { left = 1, right = 1 },
      })
    end,
  },
}
