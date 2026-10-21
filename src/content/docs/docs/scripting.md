---
title: Scripting with Lua
description: Bind Lua functions, read the open document, and build your own menus.
---

Anywhere onon takes an action, it also takes a Lua function. Functions bound to keys run once the viewer is up:

```lua
onon.bind("H", function()
  onon.page(1)
  onon.message("back to the start")
end)

onon.bind("<C-l>", function()
  onon.command("reload-config")
end)
```

`onon.command` runs anything you could type after <kbd>:</kbd>. `onon.message` shows text in the status bar.

## Reading the document

`onon.document` describes the open document: `name`, `path`, `extension`, `page_count`, `size_bytes` and `exists`. It is set while `config.lua` loads, so settings can depend on the file:

```lua
if onon.document.extension == "cbz" then
  onon.o.dual_page = true
end
```

Functions such as `onon.document.metadata()`, `onon.document.outline()` and `onon.document.selection()` read more of it. The [Lua reference](/docs/reference/#lua-functions) lists them all.

## Your own menus

`onon.ui.create` makes a searchable list that looks and behaves like onon's own menus:

```lua
onon.bind("gR", function()
  local view = onon.ui.create({
    title = "Recent files",
    rows = onon.recent_files(20),
    on_select = function(_, path) onon.open(path) end,
  })
  view:show()
end)
```

Rows can be strings or tables with `text`, `value`, `secondary`, `depth` and `disabled`.

## Modules

`require` looks beside `config.lua` first, with dots naming directories, so `require("lib.keys")` loads `lib/keys.lua`. `require("onon.json")` gives `encode` and `decode` for JSON.

For code you want to share, or that should run work in the background, write a [plugin](/docs/plugins/).
