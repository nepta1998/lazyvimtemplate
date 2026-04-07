return {
  "MeanderingProgrammer/render-markdown.nvim",
  -- dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    heading = {
      enabled = true,
      sign = true,
      style = "full",
      icons = { "① ", "② ", "③ ", "④ ", "⑤ ", "⑥ " },
      left_pad = 1,
      backgrounds = { "none", "none", "none", "none", "none", "none" },
    },
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
      right_pad = 1,
      highlight = "render-markdownBullet",
    },
    code = {
      style = "language", -- 'language' suele ser más limpio que 'full' para transparencia
      highlight = "RenderMarkdownCode",
      width = "block",
      left_pad = 0, -- Prueba bajando esto a 0 si ves la franja opaca
    },
    render_modes = { "n", "c", "i", "v" },
    padding = {
      highlight = "Normal", -- Como ya pusimos Normal = {bg="none"}, esto debería funcionar
    },
  },
}
