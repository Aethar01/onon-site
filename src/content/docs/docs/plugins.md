---
title: Plugins
description: Install plugins, and write your own with commands, actions, events, storage, timers and background jobs.
---

A plugin is a directory with a manifest and Lua code. onon finds plugins without running them. A plugin runs only when your `config.lua` asks for it:

```lua
local ok, browser = pcall(require, "file-browser")
if ok then
  onon.bind("bf", browser.actions.browse)
end
```

`pcall` keeps your config working on machines where the plugin is not installed.

## Installing

Put the plugin's directory in one of these:

| Platform | Directory |
|---|---|
| Linux | `/usr/lib/onon/plugins`, `~/.local/share/onon/plugins` (or `$XDG_DATA_HOME/onon/plugins`), `~/.config/onon/plugins` (or `$XDG_CONFIG_HOME/onon/plugins`), each `$XDG_CONFIG_DIRS/onon/plugins` |
| macOS | `~/Library/Application Support/onon/plugins`, `~/.config/onon/plugins` |
| Windows | `%LOCALAPPDATA%\onon\plugins`, `%APPDATA%\onon\plugins` |

`:reload-config` finds new ones. Where two directories hold a plugin with the same id, the first wins. `--no-plugins` starts onon without any.

### Example plugins

[onon-plugins](https://github.com/Aethar01/onon-plugins) holds two plugins: `file-browser`, which browses directories and opens documents, and `synctex`, which jumps between LaTeX source and PDF. Clone it as your plugin directory:

```bash
git clone https://github.com/Aethar01/onon-plugins ~/.config/onon/plugins
```

On Windows, clone it to `%APPDATA%\onon\plugins`. Each plugin's README lists the lines to add to `config.lua`. The plugins also make good starting points for your own.

## Writing one

```text
word-count/
├── onon-plugin.json
└── lua/
    └── word-count/
        └── init.lua
```

The manifest names the plugin. Only `id` is required:

```json
{ "id": "word-count", "version": "0.1.0", "module": "word-count", "dependencies": [] }
```

`module` picks `lua/<module>.lua` or `lua/<module>/init.lua`. The entry point registers the plugin and returns its module:

```lua
local plugin = onon.plugin.register("word-count")

plugin:register_command("show", {
  description = ":word-count-show - Count the words on this page.",
}, function()
  plugin.document:page_text(onon.page(), function(result)
    if not result.success then
      onon.message(result.error)
      return
    end
    local _, words = result.text:gsub("%S+", "")
    onon.message(words .. " words on this page")
  end)
end)

return plugin
```

This plugin adds the command `:word-count-show`. Commands are named `:plugin-id-command`, where the command's own name has no `-`. Actions are named `plugin-id.action` and options `plugin-id.option`. Register commands, actions and events while the entry point loads.

## What a plugin can do

- **Commands and actions** with `register_command` and `register_action`, which users bind like any other.
- **Events** with `on`: `document_opened`, `page_changed`, `selection_changed`, `zoom_changed`, `shutdown` and more.
- **Storage** that survives restarts, with `plugin.storage:get` and `:set`.
- **Timers**, **file system** reads and **HTTP** requests, all asynchronous.
- **Background jobs**, which run a program without a shell and call back with its output.
- **Document text and links**, read in the background.

Every asynchronous call returns a handle with `cancel()`, and callbacks run one at a time on the main Lua thread. `:reload-config` cancels a plugin's work along with its old state. The [plugin reference](/docs/reference/#plugins) covers the API, results and limits in full.
