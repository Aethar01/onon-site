---
title: Command line and editors
description: onon's options, one window per document, and forward search from LaTeX and Typst editors.
---

```sh
onon paper.pdf               # open a document
onon me@host:paper.pdf       # or one on another machine
onon --goto 20 paper.pdf     # start on page 20
onon --config my.lua paper.pdf
onon --no-config paper.pdf   # built-in defaults only
onon --no-plugins paper.pdf  # skip plugins
onon -v                      # print the version
onon -V                      # verbose logs, for bug reports
```

[Remote documents](/docs/remote/) covers web, SSH and WebDAV addresses, and `#page=N`.

## One window per document

Each window is reachable by anything that opens the same file. `--unique` hands the request to the window already showing the document, and exits:

```sh
onon --unique paper.pdf                     # bring up the window showing paper.pdf
onon --unique --goto 42 paper.pdf           # and go to page 42
onon --unique --goto 42:100:250 paper.pdf   # to a point on page 42
onon --unique --command "reload-config" paper.pdf
```

With no window showing the document, `--unique` opens one and applies `--goto` and `--command` as it starts. Without `--unique`, onon always opens a new window. A window that opens another file becomes reachable under the new one. On macOS, a document Finder or `open` sends to onon while it is running also opens in a new window; set `open_in_new_window = false` to open it in the current one.

`X` and `Y` in `--goto PAGE:X:Y` are points from the page's top-left corner, which is the convention SyncTeX uses. `--command` takes anything you could type after <kbd>:</kbd>, including commands from plugins. It exits non-zero if onon does not recognise the command.

## Editors

Point your editor's PDF viewer at `onon --unique`, so rebuilding a document reuses its window, and onon reloads the file when it changes.

With [VimTeX](https://github.com/lervag/vimtex) in Neovim:

```lua
vim.g.vimtex_view_method = "general"
vim.g.vimtex_view_general_viewer = "onon"
vim.g.vimtex_view_general_options = "--unique @pdf"
```

For forward search, have the editor ask SyncTeX where a line lands, then send onon there:

```sh
synctex view -i "142:1:chapter1.tex" -o paper.pdf
# then, with the Page, x and y it prints:
onon --unique --goto 7:72.0:340.5 paper.pdf
```

A plugin can do the SyncTeX lookup inside onon and register a command for it, so the editor only runs `onon --unique --command "…" paper.pdf`.

## Where windows listen

Sockets live under `$XDG_RUNTIME_DIR/onon` on Linux, the per-user temporary directory on macOS, and `%LOCALAPPDATA%\onon` on Windows. They are readable only by you and are named by a hash of the document's path. A socket left by a crash is reclaimed on the next start.
