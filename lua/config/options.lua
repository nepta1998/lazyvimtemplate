-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
--
vim.g.python3_host_prog = "/home/neptali/miniconda3/bin/python3" -- set default python env
vim.g.loaded_perl_provider = 0 -- fix warning to  load perl
vim.g.loaded_ruby_provider = 0 -- fix warning to  load ruby
vim.g.lazyvim_python_lsp = "basedpyright"
-- vim.g.loaded_node_provider = 0
-- vim.g.autoformat = false
if vim.fn.executable("zsh") == 1 then
  vim.opt.shell = "zsh"
else
  vim.opt.shell = "/bin/bash" -- Fallback de seguridad
end
