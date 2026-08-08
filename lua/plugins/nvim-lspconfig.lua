return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- inlay_hints = { enabled = false },
      servers = {
        basedpyright = {
          before_init = function(_, c)
            if not c.settings then
              c.settings = {}
            end
            if not c.settings.python then
              c.settings.python = {}
            end
            c.settings.python.pythonPath = vim.fn.exepath("python")
          end,
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard", -- other options include "off", "basic", and "strict"
                diagnosticMode = "openFilesOnly",
                autoImportCompletions = true,
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "information",
                  reportUnusedFunction = "information",
                  reportUnusedVariable = "information",
                  reportGeneralTypeIssues = "none",
                  reportOptionalMemberAccess = "none",
                  reportOptionalSubscript = "none",
                  reportPrivateImportUsage = "none",
                },
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              hints = {
                -- assignVariableTypes = false,
                -- compositeLiteralFields = false,
                -- compositeLiteralTypes = false,
                -- constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                -- rangeVariableTypes = false,
              },
            },
          },
        },
        clangd = {
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--header-insertion=never",
            "--query-driver=/usr/bin/g++-14,/usr/bin/g++,/usr/bin/gcc-14,/usr/bin/gcc",
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              -- Reduce drásticamente el uso de RAM (límite de memoria en caché)
              lru = {
                capacity = 32,
              },
              -- Evita picos del 100% de CPU al abrir Neovim
              cachePriming = {
                enable = false,
              },
              -- Optimiza el chequeo en segundo plano
              check = {
                command = "clippy",
                -- CRÍTICO PARA TAURI: Usa una carpeta target dedicada para el LSP.
                -- Evita que Neovim y 'tauri dev' compitan por el mismo candado de Cargo.
                extraArgs = { "--target-dir", "target/rust-analyzer" },
              },
              -- Desactiva análisis experimentales costosos
              diagnostics = {
                experimental = {
                  needlessCruft = false,
                },
              },
            },
          },
        },
      },
    },
  },
}
