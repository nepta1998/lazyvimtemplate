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

-- Trivy: escanea vulnerabilidades, secretos y misconfigs y los manda al quickfix
-- Requiere trivy (instalado via mason: mason/bin ya esta en el PATH de Neovim)
vim.keymap.set("n", "<leader>cv", function()
  local out = vim.fn.tempname() .. ".json"
  local cmd = {
    "trivy", "fs", ".",
    "--scanners", "vuln,secret,misconfig",
    "--format", "json",
    "--quiet",
    "-o", out,
  }

  vim.notify("Escaneando el proyecto... (la primera vez descarga la DB de vulns)", vim.log.levels.INFO, { title = "Trivy" })

  vim.system(cmd, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        vim.notify("Trivy fallo:\n" .. (obj.stderr or "sin salida"), vim.log.levels.ERROR, { title = "Trivy" })
        return
      end

      local raw = table.concat(vim.fn.readfile(out), "\n")
      vim.fn.delete(out)

      local ok, report = pcall(vim.json.decode, raw)
      if not ok or type(report) ~= "table" then
        vim.notify("No se pudo parsear el reporte JSON de Trivy", vim.log.levels.ERROR, { title = "Trivy" })
        return
      end

      -- Cada Result trae un Target (archivo) con sus Vulnerabilities/Secrets/Misconfigs
      local items = {}
      local counts = { vuln = 0, secret = 0, misconfig = 0 }
      for _, result in ipairs(report.Results or {}) do
        local file = result.Target
        local buckets = {
          { list = result.Vulnerabilities, kind = "vuln" },
          { list = result.Secrets, kind = "secret" },
          { list = result.Misconfigurations, kind = "misconfig" },
        }
        for _, bucket in ipairs(buckets) do
          for _, finding in ipairs(bucket.list or {}) do
            counts[bucket.kind] = counts[bucket.kind] + 1
            -- Los hallazgos traen su linea en Locations (o directo en StartLine)
            local loc = (finding.Locations and finding.Locations[1]) or {}
            local line = loc.StartLine or finding.StartLine or 1
            local id = finding.VulnerabilityID or finding.RuleID or finding.ID or "?"
            table.insert(items, {
              filename = file,
              lnum = line,
              text = string.format("[%s] %s %s", finding.Severity or "UNKNOWN", id, finding.Title or ""),
            })
          end
        end
      end

      vim.fn.setqflist({}, " ", {
        title = string.format(
          "Trivy: %d hallazgos (%d vuln, %d secretos, %d misconfig)",
          #items, counts.vuln, counts.secret, counts.misconfig
        ),
        items = items,
      })

      if #items == 0 then
        vim.notify("Sin hallazgos ✅", vim.log.levels.INFO, { title = "Trivy" })
      else
        vim.notify(string.format("Trivy: %d hallazgos — :copen para verlos", #items), vim.log.levels.WARN, { title = "Trivy" })
        vim.cmd("copen")
      end
    end)
  end)
end, { desc = "Trivy: escanear vulnerabilidades/secretos -> quickfix" })
