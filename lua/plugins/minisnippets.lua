return {
  -- Nueva ubicación del repositorio
  "nvim-mini/mini.snippets",
  opts = {
    mappings = {
      -- Al presionar Esc, se detiene la sesión del snippet y limpia las marcas
      stop = "<Esc>",
    },
  },
  config = function(_, opts)
    -- Cargamos la configuración de mini.snippets
    require("mini.snippets").setup(opts)

    -- AUTOCOMANDO: Limpieza automática al salir del modo insertar
    -- Esto asegura que las marcas desaparezcan aunque no uses la tecla 'stop'
    vim.api.nvim_create_autocmd("InsertLeave", {
      callback = function()
        if _G.MiniSnippets and _G.MiniSnippets.session.get() ~= nil then
          _G.MiniSnippets.session.stop()
        end
      end,
    })
  end,
}
