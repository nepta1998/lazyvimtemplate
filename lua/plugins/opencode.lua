return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `snacks` provider.
    ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },

  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true
  end,
  keys = {
    {
      "<leader>1t",
      function()
        require("opencode").toggle()
      end,
      desc = "Toggle Opencode",
    },
    {
      "<leader>1a",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      desc = "Ask opencode…",
      mode = { "n", "v" },
    },
    {
      "<leader>1c",
      function()
        require("opencode").select()
      end,
      desc = "Execute opencode action…",
      mode = { "n", "v" },
    },
    {
      "<leader>1gr",
      function()
        return require("opencode").operator("@this ")
      end,
      desc = "Add range to opencode",
      expr = true,
      mode = { "n", "x" },
    },
    {
      "<leader>1go",
      function()
        return require("opencode").operator("@this ") .. "_"
      end,
      desc = "Add line to opencode",
      expr = true,
    },
    {
      "<leader>1u",
      function()
        require("opencode").command("session.half.page.up")
      end,
      desc = "Scroll opencode up",
    },
    {
      "<leader>1d",
      function()
        require("opencode").command("session.half.page.down")
      end,
      desc = "Scroll opencode down",
    },
    {
      "<C-\\>",
      function()
        require("opencode").toggle()
      end,
      desc = "Toggle opencode",
      mode = { "t" },
    },
  },
}

-- return {
--   "NickvanDyke/opencode.nvim",
--   dependencies = {
--     { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
--   },
--   keys = {
--     {
--       "<leader>aa",
--       function()
--         require("opencode").toggle()
--       end,
--       mode = { "n" },
--       desc = "Toggle OpenCode",
--     },
--     {
--       "<leader>as",
--       function()
--         require("opencode").select({ submit = true })
--       end,
--       mode = { "n", "x" },
--       desc = "OpenCode select",
--     },
--     {
--       "<leader>ai",
--       function()
--         require("opencode").ask("", { submit = true })
--       end,
--       mode = { "n", "x" },
--       desc = "OpenCode ask",
--     },
--     {
--       "<leader>aI",
--       function()
--         require("opencode").ask("@this: ", { submit = true })
--       end,
--       mode = { "n", "x" },
--       desc = "OpenCode ask with context",
--     },
--     {
--       "<leader>ab",
--       function()
--         require("opencode").ask("@file ", { submit = true })
--       end,
--       mode = { "n", "x" },
--       desc = "OpenCode ask about buffer",
--     },
--     {
--       "<leader>ap",
--       function()
--         require("opencode").prompt("@this", { submit = true })
--       end,
--       mode = { "n", "x" },
--       desc = "OpenCode prompt",
--     },
--     -- Built-in prompts
--     {
--       "<leader>ape",
--       function()
--         require("opencode").prompt("explain", { submit = true })
--       end,
--       mode = { "n", "x" },
--       desc = "OpenCode explain",
--     },
--     {
--       "<leader>apf",
--       function()
--         require("opencode").prompt("fix", { submit = true })
--       end,
--       mode = { "n", "x" },
--       desc = "OpenCode fix",
--     },
--     {
--       "<leader>apd",
--       function()
--         require("opencode").prompt("diagnose", { submit = true })
--       end,
--       mode = { "n", "x" },
--       desc = "OpenCode diagnose",
--     },
--     {
--       "<leader>apr",
--       function()
--         require("opencode").prompt("review", { submit = true })
--       end,
--       mode = { "n", "x" },
--       desc = "OpenCode review",
--     },
--     {
--       "<leader>apt",
--       function()
--         require("opencode").prompt("test", { submit = true })
--       end,
--       mode = { "n", "x" },
--       desc = "OpenCode test",
--     },
--     {
--       "<leader>apo",
--       function()
--         require("opencode").prompt("optimize", { submit = true })
--       end,
--       mode = { "n", "x" },
--       desc = "OpenCode optimize",
--     },
--   },
--   config = function()
--     vim.g.opencode_opts = {
--       provider = {
--         snacks = {
--           win = {
--             position = "left",
--           },
--         },
--       },
--     }
--     vim.o.autoread = true
--   end,
-- }
