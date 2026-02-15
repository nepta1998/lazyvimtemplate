-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Filtro agresivo para errores de callback en Neovim 0.11+
local original_handler = vim.lsp.handlers["window/showMessage"]
vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
  if params and params.message and params.message:match("NO_RESULT_CALLBACK_FOUND") then
    return
  end
  if original_handler then
    original_handler(err, method, params, client_id)
  end
end

-- También silenciamos el log del cliente RPC
local client_notify = vim.lsp.rpc.client_errors
if client_notify then
  vim.lsp.rpc.client_errors[vim.lsp.rpc.client_errors.NO_RESULT_CALLBACK_FOUND] = nil
end

-- Detener clientes LSP limpiamente antes de salir
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      -- terminate() cierra el proceso del servidor inmediatamente
      if client.terminate then
        client.terminate()
      else
        client.stop()
      end
    end
  end,
})
