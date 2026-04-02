-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
--
vim.keymap.set("n", "<leader>gA", function()
  -- Capturamos la salida de gh auth status
  local handle = io.popen("gh auth status 2>&1")
  local result = handle:read("*a")
  handle:close()

  -- Buscamos los nombres de usuario después de la palabra 'account'
  local users = {}
  local active_icon = "✅ "
  for user in result:gmatch("account%s+([%w%-%_]+)") do
    local prefix = (#users == 0) and active_icon or ""
    table.insert(users, prefix .. user)
  end

  if #users > 0 then
    vim.ui.select(users, {
      prompt = "Seleccionar cuenta de GitHub:",
    }, function(choice)
      if choice then
        if choice:find("^" .. active_icon) then
          vim.notify("La cuenta " .. choice .. " ya esta activa: ", vim.log.levels.INFO, { title = "GitHub CLI" })
          return
        end
        --Ejecutamos el cambio de cuenta usando el flag --user (-u)
        local cmd = "gh auth switch -u " .. choice
        os.execute(cmd)
        -- Notificación visual del cambio
        vim.notify("Cambiado a: " .. active_icon .. choice, vim.log.levels.INFO, { title = "GitHub CLI" })
        -- Recargamos Octo si está activo para refrescar el token
        pcall(vim.cmd, "Octo pr reload")
      end
    end)
  else
    vim.notify("No se encontraron cuentas. Salida de gh:\n" .. result, vim.log.levels.WARN)
  end
end, { desc = "Switch GitHub Account" })

vim.keymap.set("n", "<leader>ct", function()
  -- Lógica para Copilot
  local cp_client = require("copilot.client")
  local cp_command = require("copilot.command")

  -- Lógica para Supermaven
  local sm_api = require("supermaven-nvim.api")

  if cp_client.is_disabled() then
    -- ACTIVAR AMBOS
    cp_command.enable()
    sm_api.start() -- Inicia el binario de Supermaven
    vim.notify("IA Activada: Copilot 🤖 & Supermaven ⚡", "info", { title = "AI Status" })
  else
    -- DESACTIVAR AMBOS
    cp_command.disable()
    sm_api.stop() -- Detiene el proceso de Supermaven por completo
    vim.notify("IA Desactivada: Copilot 🌑 & Supermaven ❄️", "warn", { title = "AI Status" })
  end
end, { desc = "Toggle Copilot and Supermaven AI" })
