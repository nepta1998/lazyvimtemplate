return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  opts = {
    sources = {
      require("null-ls").builtins.diagnostics.trivy,
      require("none-ls.diagnostics.flake8"),
      require("null-ls").builtins.formatting.black,
      require("null-ls").builtins.formatting.isort,
      require("null-ls").builtins.formatting.prettierd,
    },
    -- 2. Configuramos el root_dir (opcional, pero recomendado)
    root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
  },
}
