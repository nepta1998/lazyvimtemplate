return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      -- Esto evita que el previewer intente "adivinar" tipos de archivos binarios 
      -- que suelen causar el cuelgue y el error de Window ID
      preview = {
        check_mime_type = true,
        timeout = 250, -- Si tarda más de 250ms, aborta (evita el crash)
      },
    },
  },
}
