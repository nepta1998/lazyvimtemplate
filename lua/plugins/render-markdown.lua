return {
  "MeanderingProgrammer/render-markdown.nvim",
  -- dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    heading = {
      backgrounds = { "none", "none", "none", "none", "none", "none" },
    },
    code = {
      style = "language", -- 'language' suele ser más limpio que 'full' para transparencia
      highlight = "RenderMarkdownCode",
      width = "block",
      left_pad = 0, -- Prueba bajando esto a 0 si ves la franja opaca
    },
    padding = {
      highlight = "Normal", -- Como ya pusimos Normal = {bg="none"}, esto debería funcionar
    },
  },
}
