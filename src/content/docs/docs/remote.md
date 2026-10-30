---
title: Remote documents
description: Open documents from a web server, over SSH or from WebDAV, save edits back, and add names of your own.
---

onon opens documents on a web server, an SSH host or a WebDAV server, from the command line and with `:open`:

```sh
onon https://example.com/paper.pdf
onon sftp://me@host/srv/docs/paper.pdf        # /srv/docs/paper.pdf on host
onon sftp://me@host/~/paper.pdf               # paper.pdf in your home directory
onon me@host:papers/paper.pdf                 # scp style, from your home directory
onon davs://cloud.example.com/remote.php/dav/files/me/paper.pdf
onon 'https://example.com/paper.pdf#page=12'  # open at page 12
```

onon downloads the document to its cache and opens it from there. The status bar shows the download, and <kbd>Esc</kbd> cancels it. Your place, marks and recent files keep the address, so reopening a document puts you where you left it, and it is downloaded again only if it has changed. `:open name` from a remote document opens `name` beside it on the same host.

A `#page=N` at the end of an address, as links to papers often have, opens at that page unless `--goto` says otherwise.

## SSH

`sftp://`, `ssh://` and `scp://` all mean the same thing. A port goes after the host, as in `sftp://host:2222/…`. A path after the host is absolute, as it is in curl and in file managers. If there is no file there, onon looks in your home directory, so `ssh://host/paper.pdf` finds `~/paper.pdf`. In scp style, a local file of the same name wins, as it does for scp; write `./host:file` to mean the local one.

onon runs your system's `ssh`, so `~/.ssh/config`, host aliases, `ProxyJump`, the agent and `known_hosts` all apply. When ssh asks for a password, a key's passphrase or whether to trust a new host, onon asks in the status bar, even when it was not started from a terminal. <kbd>Esc</kbd> refuses. This needs OpenSSH 8.4 or later, which current Linux, macOS and Windows 11 have, and an SFTP server on the host, which OpenSSH has by default.

## WebDAV

`davs://` and `dav://` (or `webdavs://` and `webdav://`) name a file on a WebDAV server, such as Nextcloud, ownCloud or a NAS. They are fetched over https and http, with the same logins and headers as web documents.

## Logins and tokens

When a web server asks for a login, onon tries one given in the address (`https://me:pass@host/…`), then one in `~/.netrc`, as curl and wget read it, and then asks for a user name and password in the status bar. A login that works is kept in memory until onon quits. None is saved, and a password in an address is left out of what your history keeps.

For an API token or any other header, set `http_headers` by host, `host:port` or `*.domain`. Reading the value from the environment keeps it out of your config:

```lua
onon.o.http_headers = {
  ["api.example.com"] = { Authorization = "Bearer " .. os.getenv("EXAMPLE_TOKEN") },
  ["*.internal.example"] = { ["X-Api-Key"] = os.getenv("INTERNAL_KEY") },
}
```

Headers go only to the host they are set for, even after a redirect, and `:set` shows their names but not their values. Logins made in a web page, such as single sign-on, need a browser; a shared or signed download link works instead.

## Saving

`:w` saves edits back over SSH and to WebDAV. If the file has changed since you opened it, `:w` refuses, and `:w!` saves over it anyway. With `auto_reload` on, onon checks these documents for changes every few seconds.

Documents from a web server are read-only. `:w ~/paper.pdf` saves a copy.

## Names of your own

`onon.register_scheme` adds a name of your own. Its function gets what follows the name and returns the address or path to open, which may end in `#page=N`:

```lua
onon.register_scheme("arxiv", function(id) return "https://arxiv.org/pdf/" .. id end)
onon.register_scheme("papers", function(name)
  return "davs://cloud.example.com/dav/papers/" .. name .. ".pdf"
end)
```

Then `onon arxiv:2401.12345` or `:open papers:smith2024` opens it. A local file of the same name wins.
