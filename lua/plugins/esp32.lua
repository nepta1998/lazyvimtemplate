return {
  -- 1. Plugin principal de ESP32 con tus atajos personalizados
  {
    "Aietes/esp32.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = {
      build_dir = "build",
    },
    keys = {
      { "<leader>6b", function() require("esp32").build() end,             desc = "ESP32: Build" },
      { "<leader>6M", function() require("esp32").pick("monitor") end,       desc = "ESP32: Pick & Monitor" },
      { "<leader>6m", function() require("esp32").command("monitor") end,    desc = "ESP32: Monitor" },
      { "<leader>6F", function() require("esp32").pick("flash") end,         desc = "ESP32: Pick & Flash" },
      { "<leader>6f", function() require("esp32").command("flash") end,      desc = "ESP32: Flash" },
      { "<leader>6c", function() require("esp32").command("menuconfig") end, desc = "ESP32: Configure" },
      { "<leader>6C", function() require("esp32").command("clean") end,      desc = "ESP32: Clean" },
      { "<leader>6r", ":ESPReconfigure<CR>",                                 desc = "ESP32: Reconfigure project" },
      { "<leader>6i", ":ESPInfo<CR>",                                        desc = "ESP32: Project Info" },
      { "<leader>6t", ":ESPSetTarget<CR>",                                   desc = "ESP32: Set Target" },
    },
    config = function(_, opts)
      require("esp32").setup(opts)
      -- Borra los mapeos por defecto con prefijo <leader>R
      for _, k in ipairs({ "b", "M", "m", "F", "f", "c", "C", "r", "i", "t" }) do
        pcall(vim.keymap.del, "n", "<leader>R" .. k)
      end
    end,
  },

  -- 2. Conexión segura del LSP (clangd)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local ok, esp32 = pcall(require, "esp32")
      if ok then
        opts.servers = opts.servers or {}
        opts.servers.clangd = esp32.lsp_config()
      end
    end,
  },

  -- 3. (Opcional) Personalización de la ventana flotante de terminal
  {
    "folke/snacks.nvim",
    opts = {
      styles = {
        esp32_terminal = {
          width = 0.85,
          height = 0.75,
          border = "rounded",
        },
      },
    },
  },
}
