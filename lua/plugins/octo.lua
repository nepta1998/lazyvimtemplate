return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  -- Cambiamos a un evento más estándar para asegurar que cargue a tiempo
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim", -- Forzamos la carga para evitar el error de picker
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    enable_builtin = true,
    default_to_projects_v2 = true,
    default_merge_method = "squash",
    picker = "telescope",
  },
  config = function(_, opts)
    require("octo").setup(opts)

    -- Autocomando para registrar los grupos en Which-Key
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "octo",
      callback = function()
        local ok, wk = pcall(require, "which-key")
        if ok then
          wk.add({
            { "<localleader>a", group = "assignee" },
            { "<localleader>c", group = "comment/code" },
            { "<localleader>g", group = "goto_issue" },
            { "<localleader>i", group = "issue" },
            { "<localleader>l", group = "label" },
            { "<localleader>p", group = "pr" },
            { "<localleader>r", group = "react" },
            { "<localleader>v", group = "review" },
          }, { buffer = true })
        end
      end,
    })
  end,
}
