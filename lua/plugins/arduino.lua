return {
  -- 1. Instalar LSP y formateador en Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "arduino-language-server",
        "clangd",
        "clang-format",
      })
    end,
  },

  -- 2. Configurar LSP con la ruta de arduino-cli y placa por defecto
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        arduino_language_server = {
          cmd = {
            "arduino-language-server",
            "-cli-config",
            vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
            "-fqbn",
            "arduino:avr:uno",
          },
        },
      },
    },
  },

  -- 3. Formateo automático al guardar con Conform
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        arduino = { "clang_format" },
      },
    },
  },

  -- 4. Plugin Arduino-Nvim con sus comandos reales (:Ino...)
  {
    "yuukiflow/arduino-nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = { "arduino" },
    cmd = {
      "InoCheck",
      "InoUpload",
      "InoUploadReset",
      "InoMonitor",
      "InoStatus",
      "InoLib",
      "InoGUI",
      "InoSelectPort",
      "InoSelectBoard",
    },
    keys = {
      { "<leader>5c", "<cmd>InoCheck<cr>", desc = "Arduino: Compilar" },
      { "<leader>5u", "<cmd>InoUpload<cr>", desc = "Arduino: Subir" },
      { "<leader>5m", "<cmd>InoMonitor<cr>", desc = "Arduino: Monitor Serie" },
      { "<leader>5b", "<cmd>InoSelectBoard<cr>", desc = "Arduino: Seleccionar Placa" },
      { "<leader>5p", "<cmd>InoSelectPort<cr>", desc = "Arduino: Seleccionar Puerto" },
      { "<leader>5s", "<cmd>InoStatus<cr>", desc = "Arduino: Estado" },
      { "<leader>5l", "<cmd>InoLib<cr>", desc = "Arduino: Librerías" },
      { "<leader>5g", "<cmd>InoGUI<cr>", desc = "Arduino: Interfaz Configuración" },
    },
    config = function()
      require("Arduino-Nvim").setup()
    end,
  },
}
