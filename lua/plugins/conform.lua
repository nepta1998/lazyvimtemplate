-- lua/plugins/conform.lua (o lint.lua, elige uno solo para ambos)
return {
  -- 1. CONFORM: Formateo con black e isort
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile", "BufWritePost" },
    opts = {
      formatters_by_ft = {
        python = { "isort", "black" },
        fish = nil,
      },
      -- Ejecutar formateo al guardar
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_fallback = true,
      -- },
    },
    -- config = function(_, opts)
    --   require("conform").setup(opts)
    -- end,
  },

  -- 2. NVIM-LINT: Linting con flake8
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- Herramientas que SOLO INFORMAN (diagnósticos)
      linters_by_ft = {
        python = { "flake8" },
        dockerfile = { "trivy" },
        -- Puedes añadir trivy a otros si quieres
        terraform = { "trivy" },
      },
    },
  },
}
