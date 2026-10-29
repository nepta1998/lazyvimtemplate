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

    -- En herdr, `terminal-browser open --split` crea el pane con su propia
    -- shell y recién después corre el browser adentro: cuando el browser sale,
    -- la shell sigue viva y el split queda colgado. Abriendo el pane nosotros,
    -- un script cierra el pane apenas el browser termina.
    --
    -- El cierre va en un archivo y no encadenado con `;` dentro de `herdr pane
    -- run`: herdr escapa los metacaracteres al encolar el comando, así que
    -- `a; b` le llega a `a` como argumento literal.
    local function herdr_script(url, pane)
      local dir = vim.fs.joinpath(vim.fn.stdpath("cache"), "mkdp")
      vim.fn.mkdir(dir, "p")
      local script = vim.fs.joinpath(dir, "close-pane-" .. pane:gsub("%W", "_") .. ".sh")
      vim.fn.writefile({
        "#!/bin/sh",
        string.format("terminal-browser %s", vim.fn.shellescape(url)),
        'rm -f -- "$0"',
        string.format("herdr pane close %s", pane),
      }, script)
      return script
    end

    local function herdr_split(url)
      local origin = vim.env.HERDR_PANE_ID
      if not origin or origin == "" or vim.fn.executable("herdr") == 0 then
        return false
      end

      local ok, split = pcall(function()
        return vim.system({
          "herdr", "pane", "split",
          "--pane", origin,
          "--direction", "right",
          "--focus",
          "--right-click", "pane",
        }, { text = true }):wait()
      end)
      if not ok or split.code ~= 0 then
        return false
      end

      local decoded_ok, decoded = pcall(vim.json.decode, split.stdout)
      local pane = decoded_ok and decoded.result and decoded.result.pane and decoded.result.pane.pane_id
      if not pane then
        return false
      end

      vim.fn.jobstart({
        "herdr", "pane", "run", pane,
        string.format("sh %s", vim.fn.shellescape(herdr_script(url, pane))),
      }, { detach = true })

      return true
    end

    _G.MkdpOpenInTerminalBrowserLua = function(url)
      if herdr_split(url) then
        return
      end

      -- tmux / ghostty / kitty: el pane corre el browser como proceso propio,
      -- así que tmux o el emulador lo cierran solos cuando el browser sale.
      vim.fn.jobstart({ "terminal-browser", "open", url, "--split", "right" }, { detach = true })
    end

    vim.cmd([[
      function! MkdpOpenInTerminalBrowser(url) abort
        call luaeval('_G.MkdpOpenInTerminalBrowserLua(_A)', a:url)
      endfunction
    ]])
  end,
}
