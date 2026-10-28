---
title: Scripting with Lua
description: Bind Lua functions, read the open document, and build your own menus and panels.
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

## Your own menus and panels

`onon.ui.create` makes a view that looks and behaves like onon's own menus, which are made the same way. The simplest is a searchable list:

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

Rows can be strings or tables with `text`, `value`, `secondary`, `depth`, `disabled`, `key`, `heading`, `checked` and more, and `columns` lays them out as a table.

A view needn't be a menu. With `modal = false` it is a panel that stays open over the document, placed with `anchor`, pinned to a point or a page with `at`, or docked against a side of the window with `dock`, taking that side from the document. A `draw` function draws its body however you like, with text, shapes, images and the document's own pages:

```lua
-- A sidebar of page thumbnails; clicking one goes to it.
local sidebar = onon.ui.create({
  dock = "left", width = 144, resizable = true,
  draw = function(canvas, box)
    local col = canvas:column({ x = 12, y = 8 })
    for page = 1, onon.page_count() do
      local y = col:y()
      local w, h = col:page(page)
      if canvas:region(page, 12, y, w, h) or page == onon.page() then
        canvas:stroke(canvas:path():rect(11, y - 1, w + 2, h + 2), "accent", 2)
      end
    end
  end,
  on_mouse = function(ev)
    if ev.type == "press" and ev.region then onon.page(ev.region) return true end
  end,
})
sidebar:show()
```

Draw everything a view holds: what is out of sight is neither drawn nor rendered, and what is taller than the view scrolls.

Views take typing too. A `prompt` puts a field in the header that filters the rows as you type, and `canvas:input`, `canvas:button` and `canvas:checkbox` make forms, which Tab moves through:

```lua
local form
form = onon.ui.create({
  title = "New bookmark", width = 360, height = 260,
  draw = function(canvas, box)
    local col = canvas:column({ x = 12, y = 8 })
    col:input("name", { placeholder = "Name" })
    col:input("note", { placeholder = "Note", lines = 3 })
    col:button("save", "Save")
  end,
  on_click = function(id)
    if id == "save" then
      onon.message("saved " .. form:fields().name)
      form:close()
    end
  end,
})
form:show()
```

The [UI views reference](/docs/reference/#ui-views) covers every field, callback and drawing method.

## Modules

`require` looks beside `config.lua` first, with dots naming directories, so `require("lib.keys")` loads `lib/keys.lua`. `require("onon.json")` gives `encode` and `decode` for JSON.

For code you want to share, or that should run work in the background, write a [plugin](/docs/plugins/).
