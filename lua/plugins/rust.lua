-- rust-analyzer, configurado donde de verdad se lee.
--
-- LazyVim (extra lang.rust) maneja Rust con rustaceanvim y desactiva
-- `servers.rust_analyzer` de nvim-lspconfig: cualquier `settings` puesto ahí
-- nunca llega al servidor. Todo lo de rust-analyzer va acá, en
-- `vim.g.rustaceanvim`.
--
-- Perillas de costo, de mayor a menor impacto:
--   cachePriming     precalienta las caches de TODAS las dependencias al abrir:
--                    es el pico de CPU más grande y el que más se nota.
--   check en save    cada guardado dispara `cargo check` sobre el grafo.
--   numThreads       por default usa todos los hilos lógicos (acá 12).
--   lru.capacity     128 memoriza más pero come RAM; muy bajo hace recomputar.
--   targetDir        un target dir aparte obliga a compilar el grafo dos veces.
local CHECK_ON_SAVE = true -- false = el mayor ahorro; chequeá a mano con :RustLsp flyCheck
local INLAY_HINTS = false -- hints de tipos/parámetros; se recalculan al scrollear
local SKIP_BUILD_SCRIPTS = false -- true ahorra compilar build.rs de las deps, pero rompe OUT_DIR

return {
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    opts = {
      server = {
        settings = {
          ["rust-analyzer"] = {
            cachePriming = { enable = false },
            numThreads = 4, -- 6 núcleos físicos; los 12 lógicos saturan la máquina
            lru = { capacity = 64 },

            checkOnSave = CHECK_ON_SAVE,
            check = {
              command = "check", -- no "clippy": es un lint-run extra en cada save
              allTargets = false, -- sin tests/benches/examples
              -- targetDir deliberadamente sin setear: comparte `target/` con
              -- cargo/make. Un target aparte recompila ~400 crates de cero.
            },

            cargo = {
              buildScripts = { enable = not SKIP_BUILD_SCRIPTS },
              loadOutDirsFromCheck = not SKIP_BUILD_SCRIPTS,
              -- Sin features declaradas en Cargo.toml: allFeatures no aporta y
              -- el default de LazyVim (true) no cuesta nada acá.
            },

            -- sqlx::query! y utoipa los necesitan; apagarlos llena la pantalla
            -- de falsos positivos.
            procMacro = { enable = true },

            diagnostics = { experimental = { enable = false } },

            files = {
              watcher = "client",
              -- RA no respeta .gitignore: esto es lo que evita meter en el VFS
              -- el target/ (GBs), el grafo de graphify y el .sqlx.
              excludeDirs = { "target", "graphify-out", ".sqlx", ".git" },
            },

            inlayHints = INLAY_HINTS and {} or {
              typeHints = { enable = false },
              parameterHints = { enable = false },
              chainingHints = { enable = false },
              closingBraceHints = { enable = false },
              bindingModeHints = { enable = false },
              adjustmentHints = { enable = false },
              lifetimeElisionHints = { enable = "never" },
              closureReturnTypeHints = { enable = "never" },
              implicitDrops = { enable = false },
              implicitReturn = { enable = false },
            },
          },
        },
      },
    },
  },

  -- Si preferís dejar los hints del lado del cliente: LazyVim los prende para
  -- todos los filetypes y los pide por rango visible. Excluir rust acá evita
  -- las requests; el bloque `inlayHints` de arriba las haría vacías igual.
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = true,
        exclude = { "vue", "rust" },
      },
    },
  },
}
