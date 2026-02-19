return {
  -- add gruvbox
  { "rebelot/kanagawa.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-dragon", -- kanagawa, kanagawa-wave, kanagawa-dragon, kanagawa-lotus
    },
  },
}
