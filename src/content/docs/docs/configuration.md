---
title: Configuration
description: Where config.lua lives, how to set options and key bindings, and what the status bar can show.
---

onon needs no configuration. When you want different defaults or keys, write them in Lua, in a `config.lua` holding only what you change. `:config` (Settings… or Cmd-, on macOS) opens the file in your text editor, creating it if there is none. `:reload-config` applies your edits without restarting.

```lua
onon.options.dual_page = true
onon.options.fit_mode = "width"
onon.theme.font = { family = "Iosevka", size = 15 }

onon.bind("<C-d>", onon.next_page)
onon.bind("<C-u>", onon.prev_page)
```

The [example configuration](https://github.com/Aethar01/onon/blob/main/config.example.lua) lists every option and default binding, generated from the same registry the app uses.

## Where it lives

onon loads the first of these that exists:

| Platform | Location |
|---|---|
| Any | The path given with `--config` |
| Linux | `~/.config/onon/config.lua` |
| Linux | `$XDG_CONFIG_HOME/onon/config.lua` |
| Linux | Each `$XDG_CONFIG_DIRS/onon/config.lua` |
| Linux | `/etc/xdg/onon/config.lua` |
| macOS | `~/Library/Application Support/onon/config.lua` |
| macOS | `~/.config/onon/config.lua` |
| Windows | `%APPDATA%\onon\config.lua` |

`--no-config` starts from the built-in defaults, ignoring every file.

## Options

Options are fields of `onon.options`, or `onon.o` for short:

```lua
onon.o.scroll_off = 8
onon.o.smooth_scroll_dampening = 0.3
```

At runtime, `:set` inspects and changes them: `:set scroll_step?` shows a value, `:set dual_page!` toggles a boolean, and `:set scroll_step=80` sets one. The [reference](/docs/reference/#configuration-options) lists every option with its type and default.

## Key and mouse bindings

`onon.bind` takes a key or sequence and an action, or a Lua function:

```lua
onon.bind("H", onon.prev_page)
onon.bind("gg", onon.first_page)
onon.bind("<C-o>", onon.jump_backward)
onon.bind("r", function() onon.rotation(onon.rotation() + 90) end)

onon.bind_mouse("middle_down", onon.pan)
onon.bind_mouse("<C-wheel-up>", onon.zoom_in)
```

Keys in angle brackets use the names in the [reference](/docs/reference/#key-and-mouse-names): `<CR>`, `<Esc>`, `<Space>`, `<PgDn>`, `<F1>`, `<C-a>` for Control, `<A-x>` for Alt, `<D-s>` for Cmd on macOS and `<S-Tab>` for Shift. `onon.unbind` and `onon.unbind_mouse` remove a binding. Sequences that start with a digit, `'` or `"` are taken by counts and marks.

`:keybinds` edits bindings inside onon. Bindings changed there are kept in the session database and applied before `config.lua`, so where the two disagree, `config.lua` wins.

## Commands

<kbd>:</kbd> opens the command prompt. <kbd>Tab</kbd> completes commands, options and paths:

```text
:page iv           go to the page labelled iv
:search \Cmoss     search, matching case
:fit width
:open chapter2.pdf
:theme birch
:w                 save annotations
```

## Status bar

The status bar is two templates, left and right:

```lua
onon.o.status_bar_left = "{message}"
onon.o.status_bar_right = "{document}  {label}/{total}  {zoom}"
onon.o.status_bar_visible = false -- hide it
```

The placeholders include `{page}`, `{label}`, `{total}`, `{zoom}`, `{search}` and `{modified}`. The [reference](/docs/reference/#status-bar) has the full list. How the bar looks comes from the [theme](/docs/themes/).

## Session data

Each document's place, marks and zoom, recent files, prompt history, the chosen theme and keybindings changed in onon are kept in `session.sqlite`:

| Platform | Directory |
|---|---|
| Linux | `$XDG_DATA_HOME/onon` or `~/.local/share/onon` |
| macOS | `~/Library/Application Support/onon` |
| Windows | `%APPDATA%\onon` |

Set `onon.o.session_database = false` to keep nothing.
