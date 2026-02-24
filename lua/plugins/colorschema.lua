return {
  -- add gruvbox
  { "rebelot/kanagawa.nvim" },
  {
    "Gentleman-Programming/gentleman-kanagawa-blur",
    name = "gentleman-kanagawa-blur",
    priority = 1000,
    opts = {
      -- variant = "sakura_night_blur",
      -- styles = {
      --   booleans = { italic = true, bold = true },
      -- },
      highlight_overrides = {
        -- Cambia el valor de bg a "none" para que sea transparente
        LspReferenceText = { bg = "none", underline = true },
        LspReferenceRead = { bg = "none", underline = true },
        LspReferenceWrite = { bg = "none", underline = true },

        -- Resaltado de búsqueda (estos ya los tienes, asegúrate que no tengan conflictos)
        Search = { bg = "none" },
        CurSearch = { bg = "none" },

        IlluminatedWordText = { bg = "none", underline = true },
        IlluminatedWordRead = { bg = "none", underline = true },
        IlluminatedWordWrite = { bg = "none", underline = true },
        TelescopeBorder = { bg = "none" },
        PopMenu = { bg = "none", blend = 0 },

        NormalFloat = { bg = "none" },
        FloatBorder = { bg = "none" },
        Normal = { bg = "none" },
        EndOfBuffer = { bg = "none" },
        NormalNC = { bg = "none" }, -- Importante: Ventanas no enfocadas
        StatusLine = { bg = "none" },
        StatusLineNC = { bg = "none" },
        MsgArea = { bg = "none" },
        SignColumn = { bg = "none" },
        FoldColumn = { bg = "none" },
        WinBar = { bg = "none" },
        WinBarNC = { bg = "none" },
        -- Snacks Picker & Explorer (Solución para el fondo opaco)SnacksPicker = { bg = "none" },
        SnacksPickerNormal = { bg = "none" },
        SnacksPickerList = { bg = "none" },
        SnacksPickerInput = { bg = "none" },
        SnacksPickerPrompt = { bg = "none" },
        SnacksPickerBorder = { bg = "none" },
        SnacksPickerTitle = { bg = "none" },

        -- Snacks Explorer (Sidebar)
        SnacksExplorerNormal = { bg = "none" },
        SnacksExplorerNormalNC = { bg = "none" },

        -- Otros elementos de Snacks (Notifier, etc)
        SnacksNormal = { bg = "none" },
        SnacksNormalNC = { bg = "none" },

        -- ESTOS SON PARA LAS SUGERENCIAS (nvim-cmp / PUM)
        Pmenu = { bg = "none" }, -- Fondo del menú de sugerencias
        PmenuSel = { bg = "#2D4F67" }, -- Color de la sugerencia seleccionada (cámbialo si quieres)
        PmenuSbar = { bg = "none" }, -- Barra de desplazamiento
        PmenuThumb = { bg = "none" }, -- El "pulgar" de la barra de desplazamiento

        -- Para las descripciones flotantes de LSP (documentación de sugerencias)
        CmpDoc = { bg = "none" },
        CmpDocBorder = { bg = "none" },

        -- Si usas Snacks.nvim para notificaciones o sugerencias
        SnacksNotifier = { bg = "none" },
        SnacksNotifierBorder = { bg = "none" },

        -- Bordes y fondo de sugerencias de firmas de LSP
        LspSignatureActiveParameter = { bg = "none", bold = true, underline = true },

        -- Render Markdown: Encabezados transparentes
        Conceal = { bg = "none" },
        RenderMarkdownH1Bg = { bg = "none" },
        RenderMarkdownH2Bg = { bg = "none" },
        RenderMarkdownH3Bg = { bg = "none" },
        RenderMarkdownH4Bg = { bg = "none" },
        RenderMarkdownH5Bg = { bg = "none" },
        RenderMarkdownH6Bg = { bg = "none" },

        -- Render Markdown: Bloques de código y otros elementos
        RenderMarkdownCode = { bg = "none" }, -- Fondo de bloques de código
        RenderMarkdownCodeInline = { bg = "none" }, -- Fondo de código inline `like this`
        RenderMarkdownBullet = { bg = "none" },
        RenderMarkdownTableHead = { bg = "none" },
        RenderMarkdownTableRow = { bg = "none" },

        -- Si el plugin usa los grupos estándar de Treesitter
        ["@markup.heading.1.markdown"] = { bg = "none" },
        ["@markup.heading.2.markdown"] = { bg = "none" },
        ["@markup.raw.block.markdown"] = { bg = "none" },
        -- Neovim usa ColorColumn para resaltar bloques de código a veces
        ColorColumn = { bg = "none" },

        -- Grupos de Treesitter para Markdown
        ["@markup.raw.markdown_inline"] = { bg = "none" },

        -- Limpiar el fondo de los delimitadores (las comillas ```)
        ["@markup.fenced_code_block"] = { bg = "none" },

        Whitespace = { bg = "none" },
        -- Hace que la línea del cursor sea transparente
        CursorLine = { bg = "none" },

        -- Si quieres que el número de la línea resalte pero el fondo no:
        -- CursorLineNr = { fg = "#7E9CD8", bold = true }, -- Ajusta el color a tu gusto

        -- Para los límites de las ventanas (separadores verticales)
        WinSeparator = { bg = "none", fg = "#54546D" },
      },
    },
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "kanagawa-dragon", -- kanagawa, kanagawa-wave, kanagawa-dragon, kanagawa-lotus
      colorscheme = "gentleman-kanagawa-blur",
    },
  },
}
