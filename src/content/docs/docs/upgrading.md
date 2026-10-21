---
title: Upgrading from gopdf
description: gopdf was renamed onon in 0.8.0. What carries over by itself and what you need to change.
---

onon 0.8.0 is gopdf 0.7.4 under a new name, with a new icon. Your settings, history and plugins carry over, but anything that names gopdf needs changing.

## What onon does for you

The first time onon starts, it looks for gopdf's folders and copies each one to an `onon` folder beside it:

| Platform | Copied from | To |
|---|---|---|
| macOS | `~/Library/Application Support/gopdf`, `~/.config/gopdf` | `…/onon` |
| Linux | `~/.local/share/gopdf` (or `$XDG_DATA_HOME/gopdf`), `~/.config/gopdf` (or `$XDG_CONFIG_HOME/gopdf`) | `…/onon` |
| Windows | `%APPDATA%\gopdf`, `%LOCALAPPDATA%\gopdf` | `…\onon` |

The copy brings your recent files, each document's place and marks, keybindings changed in the editor, your `:theme` choice, plugin storage, `config.lua`, themes and plugins. In the copied Lua files `gopdf` becomes `onon`, and each plugin's `gopdf-plugin.json` becomes `onon-plugin.json`. The status bar says what was copied.

The old folders are left as they were, so you can go back to them. Delete them once onon is working.

onon copies nothing if an `onon` folder already exists, and leaves alone a gopdf folder that is a symbolic link. A link usually points into a dotfiles repository, which you will want to change yourself.

## What you change

- **Configuration kept elsewhere.** If `config.lua` is a link, or lives in a dotfiles repository, rename the folder to `onon` and replace `gopdf` with `onon` in its Lua files: `gopdf.bind` becomes `onon.bind`, `require("gopdf.json")` becomes `require("onon.json")`, and so on. Rename each plugin's `gopdf-plugin.json` to `onon-plugin.json`.
- **Plugins you publish.** The Lua global is `onon` and the manifest is `onon-plugin.json`. Nothing answers to the old names.
- **Scripts and editors.** The command is `onon`. Change editor integrations such as vimtex, tinymist or SyncTeX inverse search that run `gopdf`. See [Command line and editors](/docs/command-line/).
- **Default apps.** Your system knows gopdf and onon as different apps, so choose onon again as the app for PDFs and other documents.

## Packages

- **Homebrew:** `brew upgrade` replaces the `gopdf` cask with `onon`.
- **Windows installer:** installs over gopdf in place. The new shortcut and file associations are named onon.
- **AUR:** `onon-git` replaces `gopdf-git`.
