return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim", -- Indispensable para flake8
  },
  opts = function(_, opts)
    local nls = require("null-ls")
    opts.root_dir = opts.root_dir
      or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")

    opts.sources = vim.list_extend(opts.sources or {}, {
      -- Usamos la extensión externa en lugar del builtin antiguo
      require("none-ls.diagnostics.flake8"),
      nls.builtins.formatting.black,
      nls.builtins.formatting.isort,
    })
  end,
}
