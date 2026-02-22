return {
  -- add gruvbox
  { "rebelot/kanagawa.nvim" },
  {
    "Gentleman-Programming/gentleman-kanagawa-blur",
    name = "gentleman-kanagawa-blur",
    priority = 1000,
    -- opts = {
    --   variant = "sakura_night_blur",
    --   styles = {
    --     booleans = { italic = true, bold = true },
    --   },
    -- },
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-dragon", -- kanagawa, kanagawa-wave, kanagawa-dragon, kanagawa-lotus
      -- colorscheme = "gentleman-kanagawa-blur",
    },
  },
}
