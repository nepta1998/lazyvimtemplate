return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    previewers = {
      builtin = {
        -- Si quieres forzar el uso de chafa para imágenes
        extensions = {
          ["png"] = { "viu", "{file}" },
          ["jpg"] = { "viu", "{file}" },
        },
      },
    },
  },
}
