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

-- Trivy: escaneo de seguridad con dos velocidades.
--   <leader>cv -> proyecto completo (vuln + secretos + misconfigs) -> quickfix
--   <leader>cV -> solo secretos del archivo actual -> quickfix
-- Requiere trivy (instalado via mason: mason/bin ya esta en el PATH de Neovim)

local trivy = {}

-- Dependencias, builds y caches: nunca son codigo propio. Trivy NO respeta
-- .gitignore, asi que sin esto el reporte se llena de ruido de terceros.
trivy.skip_dirs = {
  ".git",
  ".hg",
  ".svn",
  "node_modules",
  "bower_components",
  "vendor",
  "dist",
  "build",
  "out",
  "target",
  ".next",
  ".nuxt",
  "coverage",
  "__pycache__",
  ".mypy_cache",
  ".pytest_cache",
  ".ruff_cache",
  ".venv",
  "venv",
  "env",
  ".tox",
  ".terraform",
  ".terragrunt-cache",
}

function trivy.ensure_installed()
  if vim.fn.executable("trivy") == 1 then
    return true
  end
  vim.notify("trivy no esta en el PATH (mason/bin)", vim.log.levels.ERROR, { title = "Trivy" })
  return false
end

-- Devuelve el root del proyecto que contiene `start` (path), o nil si no hay
-- marcador de proyecto en ningun ancestro.
function trivy.find_root(start)
  local markers = {
    ".git",
    "package.json",
    "pyproject.toml",
    "go.mod",
    "Cargo.toml",
    "composer.json",
    "Gemfile",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
  }
  return vim.fs.root(start, markers)
end

-- Root para el escaneo de proyecto: el buffer manda (si estas parado en un repo,
-- escaneas ese repo), despues el cwd, y como ultimo recurso el cwd.
function trivy.project_root()
  local buf = vim.api.nvim_buf_get_name(0)
  return (buf ~= "" and trivy.find_root(buf)) or trivy.find_root(vim.fn.getcwd()) or vim.fn.getcwd()
end

-- Trivy no permite filtrar severidad por scanner en un solo run: `--severity`
-- tambien borraria secretos MEDIUM/LOW, que siguen siendo secretos reales. Por
-- eso vuln y misconfig se filtran aca, y los secretos pasan siempre.
local MIN_SEVERITY = { CRITICAL = true, HIGH = true }

local function set_quickfix(items, counts, label, note)
  vim.fn.setqflist({}, " ", {
    title = string.format(
      "Trivy %s: %d hallazgos (%d vuln, %d secretos, %d misconfig)%s",
      label,
      #items,
      counts.vuln,
      counts.secret,
      counts.misconfig,
      note or ""
    ),
    items = items,
  })

  if #items == 0 then
    vim.notify("Trivy " .. label .. ": sin hallazgos ✅" .. (note or ""), vim.log.levels.INFO, { title = "Trivy" })
    return
  end

  vim.notify(
    string.format("Trivy %s: %d hallazgos — :copen para verlos", label, #items),
    vim.log.levels.WARN,
    { title = "Trivy" }
  )
  vim.cmd("copen")
end

-- opts = { target, base, cwd, scanners, label, ignore_unfixed, note }
--   target: path que se le pasa a trivy
--   base:   contra quien se resuelven los Target relativos del reporte (trivy
--           devuelve rutas relativas al path escaneado, o el basename si es un archivo)
--   cwd:    root del proyecto. Trivy resuelve .trivyignore y trivy-secret.yaml
--           contra el cwd del proceso, NO contra el path escaneado: sin esto los
--           ignores documentados del proyecto se pierden en silencio.
--   ignore_unfixed: descarta CVEs sin version que los arregle (solo afecta vuln)
function trivy.scan(opts)
  if not trivy.ensure_installed() then
    return
  end

  local out = vim.fn.tempname() .. ".json"
  local cmd = { "trivy", "fs", opts.target, "--scanners", opts.scanners, "--format", "json", "--quiet", "-o", out }
  if opts.ignore_unfixed then
    table.insert(cmd, "--ignore-unfixed")
  end
  for _, dir in ipairs(trivy.skip_dirs) do
    vim.list_extend(cmd, { "--skip-dirs", dir })
  end

  vim.notify(
    "Trivy: escaneando " .. opts.label .. "... (la primera vez descarga la DB de vulns)",
    vim.log.levels.INFO,
    { title = "Trivy" }
  )

  vim.system(cmd, { text = true, cwd = opts.cwd }, function(obj)
    -- El callback corre en un hilo fast-event: hay que volver al loop principal
    -- antes de tocar buffers, quickfix o notificaciones.
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

      local items = {}
      local counts = { vuln = 0, secret = 0, misconfig = 0 }
      for _, result in ipairs(report.Results or {}) do
        -- Cada Result trae un Target (archivo) con sus Vulnerabilities/Secrets/Misconfigurations
        local filename = result.Target or ""
        if filename ~= "" and not filename:match("^/") and not filename:match("^%a:[/\\]") then
          filename = vim.fs.joinpath(opts.base, filename)
        end

        local buckets = {
          { list = result.Vulnerabilities, kind = "vuln" },
          { list = result.Secrets, kind = "secret" },
          { list = result.Misconfigurations, kind = "misconfig" },
        }
        for _, bucket in ipairs(buckets) do
          for _, finding in ipairs(bucket.list or {}) do
            local severity = finding.Severity or "UNKNOWN"
            if bucket.kind == "secret" or MIN_SEVERITY[severity] then
              counts[bucket.kind] = counts[bucket.kind] + 1
              -- Los hallazgos traen su linea en Locations (o directo en StartLine)
              local loc = (finding.Locations and finding.Locations[1]) or {}
              local line = loc.StartLine or finding.StartLine or 1
              local id = finding.VulnerabilityID or finding.RuleID or finding.ID or "?"
              table.insert(items, {
                filename = filename,
                lnum = line,
                text = string.format("[%s] %s %s", severity, id, finding.Title or ""),
              })
            end
          end
        end
      end

      set_quickfix(items, counts, opts.label, opts.note)
    end)
  end)
end

vim.keymap.set("n", "<leader>cv", function()
  local root = trivy.project_root()
  trivy.scan({
    target = root,
    base = root,
    cwd = root,
    scanners = "vuln,secret,misconfig",
    label = vim.fn.fnamemodify(root, ":~"),
    ignore_unfixed = true,
    note = " — vuln/misconfig HIGH+",
  })
end, { desc = "Trivy: escanear proyecto -> quickfix" })

vim.keymap.set("n", "<leader>cV", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("El buffer actual no es un archivo", vim.log.levels.WARN, { title = "Trivy" })
    return
  end
  trivy.scan({
    target = file,
    base = vim.fs.dirname(file),
    -- sin root de proyecto, el dirname del archivo es mejor guess que el cwd
    -- de Neovim: ahi viven .trivyignore y trivy-secret.yaml
    cwd = trivy.find_root(file) or vim.fs.dirname(file),
    scanners = "secret",
    label = vim.fs.basename(file),
  })
end, { desc = "Trivy: secretos del archivo actual -> quickfix" })
