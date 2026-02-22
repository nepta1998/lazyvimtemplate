return {
  -- add gruvbox
  { "rebelot/kanagawa.nvim" },
  {
    "Gentleman-Programming/gentleman-kanagawa-blur",
    name = "gentleman-kanagawa-blur",
    priority = 1000,
    opts = {
      -- variant = "sakura_night_blur",
      -- styles = {
      --   booleans = { italic = true, bold = true },
      -- },
      highlight_overrides = {
        -- Cambia el valor de bg a "none" para que sea transparente
        -- LspReferenceText = { bg = "none", underline = true },
        -- LspReferenceRead = { bg = "none", underline = true },
        -- LspReferenceWrite = { bg = "none", underline = true },

        -- Resaltado de búsqueda (estos ya los tienes, asegúrate que no tengan conflictos)
        -- Search = { bg = "#2d4f67" },
        -- CurSearch = { bg = "#7e9cd8" },

        IlluminatedWordText = { bg = "none", underline = true },
        IlluminatedWordRead = { bg = "none", underline = true },
        IlluminatedWordWrite = { bg = "none", underline = true },

        -- SnacksExplorerNormal = { bg = "none", underline = true },
        -- NormalFloat = { bg = "none", underline = true },
        -- FloatBorder = { bg = "none", underline = true },
      },
    },
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "kanagawa-dragon", -- kanagawa, kanagawa-wave, kanagawa-dragon, kanagawa-lotus
      colorscheme = "gentleman-kanagawa-blur",
    },
  },
}
