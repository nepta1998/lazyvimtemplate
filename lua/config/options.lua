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

  vim.g.python3_host_prog = "/home/neptali/miniconda3/bin/python3" -- set default python env
end

vim.g.loaded_perl_provider = 0 -- fix warning to  load perl
vim.g.loaded_ruby_provider = 0 -- fix warning to  load ruby
vim.g.lazyvim_python_lsp = "basedpyright"
-- vim.g.loaded_node_provider = 0
vim.g.autoformat = true
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
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

-- Esto permite que Neovim use siempre el portapapeles del sistema
vim.opt.clipboard = "unnamedplus"
