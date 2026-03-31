-- return {
--   "marcocofano/excalidraw.nvim",
--   config = function()
--     require("excalidraw").setup(opts)
--   end,
-- }

return {
  "marcocofano/excalidraw.nvim",
  config = function()
    require("excalidraw").setup({
      -- Directorio donde se guardarán los archivos .excalidraw
      storage_dir = "/media/neptali/TOSHIBA EXT3/obsidian/vaults/Personal/Excalidraw",
      open_on_create = true,
      relative_path = true,
    })
  end,
}
