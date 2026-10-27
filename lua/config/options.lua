-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
--
local is_wsl = vim.fn.has("wsl") == 1

if is_wsl then
  -- Configuración específica para WSL (usando uv o pixi)
  -- Si usas uv con un venv dedicado:
  vim.g.python3_host_prog = vim.fn.expand("$HOME") .. "/.local/share/nvim/venv/bin/python3"

  -- Opcional: Desactivar plugins pesados en WSL como vimos antes
  -- vim.g.disable_obsidian = true
else
  -- Configuración para Windows nativo
  -- vim.g.python3_host_prog = "C:/Users/TuUsuario/miniconda3/python.exe"

  -- vim.g.python3_host_prog = "/home/neptali/miniconda3/bin/python3" -- set default python env
end

vim.g.loaded_perl_provider = 0 -- fix warning to  load perl
vim.g.loaded_ruby_provider = 0 -- fix warning to  load ruby
vim.g.lazyvim_python_lsp = "basedpyright"
-- vim.g.loaded_node_provider = 0
vim.g.autoformat = false
if vim.fn.executable("zsh") == 1 then
  vim.opt.shell = "zsh"
else
  vim.opt.shell = "/bin/bash" -- Fallback de seguridad
end
vim.opt.winblend = 0
vim.opt.pumblend = 0
-- Spell-checking
vim.opt.spell = true -- activa spell checker
vim.opt.spelllang = { "en" }
vim.opt.timeoutlen = 300 -- Da medio segundo de margen para que aparezca el menú
vim.g.lazyvim_mini_snippets_in_completion = true

vim.opt.termguicolors = true

-- Configuración del portapapeles para WSL en LazyVim
if is_wsl then
  vim.g.clipboard = {
    name = "win32yank",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
elseif vim.env.WAYLAND_DISPLAY then
  -- Wayland: copiar por OSC 52 mantiene el dato dentro del terminal, así que no
  -- se crea ninguna superficie; wl-copy en cambio necesita robar el foco un
  -- instante en Mutter y eso hace parpadear el dock (bugaevc/wl-clipboard#90).
  -- Pegar usa xclip sobre XWayland: wl-clipboard queda descartado a propósito
  -- porque en este equipo provoca ese mismo flash, incluso para leer.
  local function reader(primary)
    if vim.fn.executable("xclip") ~= 1 then
      return nil
    end
    local selection = primary and "primary" or "clipboard"
    -- Bajo Wayland el dueño del portapapeles llega por el puente XWayland, que
    -- no siempre expone el target STRING que xclip pide por defecto; entonces
    -- xclip sale con "Error: target STRING not available" y Neovim lo muestra
    -- como "clipboard: error: ...". Pedimos los targets de texto explícitos y
    -- degradamos a pegado vacío en silencio en vez de romper la sesión.
    local candidates = {
      ("xclip -selection %s -o -t UTF8_STRING 2>/dev/null"):format(selection),
      ("xclip -selection %s -o -t text/plain 2>/dev/null"):format(selection),
      "true",
    }
    return { "sh", "-c", table.concat(candidates, " || ") }
  end
  local clipboard, primary = reader(false), reader(true)
  if clipboard and primary then
    local osc52 = require("vim.ui.clipboard.osc52")
    vim.g.clipboard = {
      name = "osc52+reader",
      copy = {
        ["+"] = osc52.copy("+"),
        ["*"] = osc52.copy("*"),
      },
      paste = {
        ["+"] = clipboard,
        ["*"] = primary,
      },
      cache_enabled = 0,
    }
  end
end

-- Esto permite que Neovim use siempre el portapapeles del sistema
vim.opt.clipboard = "unnamedplus"
