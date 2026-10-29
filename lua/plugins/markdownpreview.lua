return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = function()
    require("lazy").load({ plugins = { "markdown-preview.nvim" } })
    vim.fn["mkdp#util#install"]()
  end,
  keys = {
    {
      "<leader>cp",
      ft = "markdown",
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "Markdown Preview",
    },
  },
  config = function()
    vim.cmd([[do FileType]])

    -- markdown-preview.nvim llama a g:mkdp_browserfunc por NOMBRE desde su
    -- servidor Node (nvim_call_function), así que tiene que existir como
    -- función Vimscript: una función en _G de Lua no es visible ahí.
    vim.g.mkdp_browserfunc = "MkdpOpenInTerminalBrowser"

    vim.cmd([[
      function! MkdpOpenInTerminalBrowser(url) abort
        call jobstart(['terminal-browser', 'open', a:url, '--split', 'right'], {'detach': v:true})
      endfunction
    ]])
  end,
}
