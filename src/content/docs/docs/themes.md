---
title: Themes
description: Pick a built-in theme, write your own, or restyle every panel, row and hint.
---

Colours, the interface font and the shape of panels all come from one table, `onon.theme`. Three themes are built in:

| Theme | Light | Dark |
|---|---|---|
| `moss`, the default | Stone-grey canvas, moss-green accent | Forest charcoal |
| `birch` | Cream paper, bark-brown accent | Dark wood |
| `classic` | The flat greys of earlier releases | Black |

`:theme` changes the theme. It lists the built-in themes and your theme files, and shows each one as you move to it. <kbd>Enter</kbd> keeps the selected theme and onon remembers it.

## Changing a few things

Set single fields, and the rest stay as they are:

```lua
onon.theme.accent = "#335533"
onon.theme.radius = 0
onon.theme.font = { family = "Iosevka", size = 14 }
```

At runtime, `:set theme.radius=0` does the same. With no `font.family`, onon uses the system's interface font.

## Writing a theme

A theme is a table. Fields you leave out come from its `base`:

```lua
onon.theme = {
  base = "birch",
  accent = "#335533",
  alt = { accent = "#88aa88" },  -- colours for alternate-colour mode
  status_bar_style = "pill",     -- float the status bar over the page
  motion = { scale = 0 },        -- no animation
}
```

Put a theme in its own file in `themes/`, beside `config.lua`, or in any theme directory. The file returns its table:

```lua
-- themes/forest.lua
return { base = "moss", accent = "#2f5d3a", alt = { accent = "#8fbf8f" } }
```

Choose it with `:theme forest`, or in `config.lua` with `onon.theme = require("themes.forest")`. A theme assigned in `config.lua` replaces the one picked with `:theme` each time onon starts. Single fields set in `config.lua` apply on top of whichever theme is picked.

Theme files are found beside `config.lua` first, then in these directories:

| Platform | Directory |
|---|---|
| Linux | `/usr/lib/onon/themes`, `~/.local/share/onon/themes`, `~/.config/onon/themes`, each `$XDG_CONFIG_DIRS/onon/themes` |
| macOS | `~/Library/Application Support/onon/themes`, `~/.config/onon/themes` |
| Windows | `%LOCALAPPDATA%\onon\themes`, `%APPDATA%\onon\themes` |

## Elements

Past that, each element can be restyled. Each panel, menu row, status bar section and link hint has its own fill, border, shadows, padding and shape. A shape is SVG path data or a Lua function, and an element's `draw` function can draw its box however it likes:

```lua
onon.theme.elements = {
  panel = { radius = 14, shadow = "0 8 24 shadow" },
  row_selected = { fill = "accent", text = "panel" },
  status_left = { shape = "M0,0 H100%-8 L100%,50% L100%-8,100% H0 Z" },
  hint = {
    draw = function(canvas, box, state)
      canvas:default()
      canvas:stroke("M0,100% H100%", "accent", 2) -- underline each hint
    end,
  },
}
```

The [reference](/docs/reference/#theme) lists every theme field and element, with the drawing functions available to `draw`.
