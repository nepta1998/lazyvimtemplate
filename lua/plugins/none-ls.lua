
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  opts = function(_, opts)
    local nls = require("null-ls")
    
    -- 1. Aseguramos el root_dir
    opts.root_dir = opts.root_dir
      or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")

    -- 2. Definimos las fuentes (limpiando las problemáticas)
    local sources = {
      require("none-ls.diagnostics.flake8"),
      nls.builtins.formatting.black,
      nls.builtins.formatting.isort,
      -- Añadimos Prettier para Markdown pero evitamos el linter que crashea
      nls.builtins.formatting.prettierd,
    }

    -- 3. Combinamos con las fuentes que LazyVim ya trae
    opts.sources = vim.list_extend(opts.sources or {}, sources)

    -- 4. FILTRO CRÍTICO: Eliminamos lo que da error (fish y markdownlint)
    opts.sources = vim.tbl_filter(function(source)
      -- Quitamos fish y el linter de markdown que causa el "index out of range"
      return not (source.name:find("fish") or source.name:find("markdownlint"))
    end, opts.sources)
  end,
}

