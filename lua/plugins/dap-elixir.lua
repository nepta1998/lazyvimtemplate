-- Registers the Elixir DAP adapter WITHOUT contributing a second `config`
-- to the `mfussenegger/nvim-dap` spec. LazyVim's `dap.core` extra owns that
-- spec (its `config` defines the Dap* signs with nerd icons, the JSON-decoder
-- patch for launch.json and loads mason-nvim-dap); a second `config` on the
-- same plugin id clobbers it, which leaves nvim-dap's built-in ASCII signs
-- (DapBreakpoint == "B", dap.lua:432) behind — the "gráfico se daña" symptom.
--
-- Implemented as a local dir-based plugin instead, so the registration runs
-- as a separate plugin alongside the extra. `dependencies` guarantees
-- LazyVim's nvim-dap `config` has already run before we add the adapter.
return {
  {
    name = "dap-elixir-adapter",
    dir = vim.fn.stdpath("config") .. "/lua/local/dap-elixir",
    ft = { "elixir", "eelixir" },
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap = require("dap")

      -- ElixirLS debug adapter shipped by mason.
      dap.adapters.mix_task = {
        type = "executable",
        command = vim.fn.expand("~/.local/share/nvim/mason/packages/elixir-ls/debug_adapter.sh"),
        args = {},
      }

      -- ElixirLS advertises `exceptionBreakpointFilters: []` but does not
      -- implement `setExceptionBreakpoints`. nvim-dap treats the empty key as
      -- truthy and sends the request on every session start, which makes the
      -- adapter respond with an error notification. Strip the empty key
      -- before nvim-dap stores the capabilities so the request is never sent.
      dap.listeners.before.capabilities["elixir_ls_strip_bpfilters"] = function(_session, err, response)
        if not err and response and response.body
          and vim.tbl_isempty(response.body.exceptionBreakpointFilters or {}) then
          response.body.exceptionBreakpointFilters = nil
        end
      end
      dap.listeners.before.event_capabilities["elixir_ls_strip_bpfilters"] = function(_session, body)
        if body and body.capabilities
          and vim.tbl_isempty(body.capabilities.exceptionBreakpointFilters or {}) then
          body.capabilities.exceptionBreakpointFilters = nil
        end
      end
    end,
  },
}
