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

    -- HERDR_PANE_ID no alcanza para saber si estamos dentro de herdr: un tmux
    -- arrancado desde un pane de herdr hereda esa variable en su entorno global
    -- y la replica en todos sus panes. Ahí `herdr pane split` abre el preview en
    -- la ventana de herdr, no en el tmux donde corre nvim, y parece que no pasa
    -- nada. TERM_PROGRAM distingue los dos multiplexores.
    local function in_herdr_pane()
      return vim.env.TERM_PROGRAM == "herdr"
    end

    -- terminal-browser elige su adaptador por HERDR_PANE_ID antes que por TMUX,
    -- así que con la variable heredada abriría el split en herdr aunque estemos
    -- en tmux. Vacía para que caiga en el adaptador de tmux, que es donde corre
    -- nvim. En JS una cadena vacía es falsy, que es lo que espera su detección.
    local HERDR_ENV_VARS = { "HERDR_PANE_ID", "HERDR_TAB_ID", "HERDR_WORKSPACE_ID", "HERDR_ENV" }

    local function without_herdr_env()
      local env = {}
      for _, name in ipairs(HERDR_ENV_VARS) do
        env[name] = ""
      end
      return env
    end

    local function herdr_split(url)
      local origin = vim.env.HERDR_PANE_ID
      if not in_herdr_pane() or not origin or origin == "" or vim.fn.executable("herdr") == 0 then
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

    -- En tmux el split lo hacemos nosotros y no `terminal-browser --split`.
    -- terminal-browser crea el pane con el entorno del servidor de tmux, así que
    -- las HERDR_* heredadas vuelven a aparecer adentro. Con HERDR_PANE_ID puesta
    -- elige su adaptador de herdr antes que el de tmux y no envuelve los gráficos
    -- en passthrough DCS; tmux no entiende kitty graphics (solo sixel) y los
    -- descarta, dejando el pane vacío. Con el entorno limpio sí detecta tmux y
    -- envuelve cada frame.
    local function tmux_split(url)
      local pane = vim.env.TMUX_PANE
      if not pane or pane == "" or vim.fn.executable("tmux") == 0 then
        return false
      end

      local unset = {}
      for _, name in ipairs(HERDR_ENV_VARS) do
        table.insert(unset, "-u")
        table.insert(unset, name)
      end

      local cmd = table.concat({
        "env ", table.concat(unset, " "),
        " terminal-browser ", vim.fn.shellescape(url),
      })

      local ok, split = pcall(function()
        return vim.system({ "tmux", "split-window", "-h", "-t", pane, cmd }):wait()
      end)

      return ok and split.code == 0
    end

    _G.MkdpOpenInTerminalBrowserLua = function(url)
      if herdr_split(url) then
        return
      end

      if tmux_split(url) then
        return
      end

      -- kitty / wezterm: el pane corre el browser como proceso propio,
      -- así que el multiplexor o el emulador lo cierran solos cuando el browser
      -- sale.
      --
      -- Ojo: en Linux el adaptador de ghostty de terminal-browser no soporta
      -- splits (usa AppleScript, es solo macOS) y falla con "ghostty cannot
      -- open panes from a command". Ahí hay que correr nvim dentro de tmux,
      -- herdr o kitty.
      vim.fn.jobstart({ "terminal-browser", "open", url, "--split", "right" }, {
        detach = true,
        env = without_herdr_env(),
      })
    end

    vim.cmd([[
      function! MkdpOpenInTerminalBrowser(url) abort
        call luaeval('_G.MkdpOpenInTerminalBrowserLua(_A)', a:url)
      endfunction
    ]])
  end,
}
