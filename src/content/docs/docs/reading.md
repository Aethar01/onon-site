---
title: Reading
description: Moving through a document, searching it, following links, marking places, highlighting and presenting.
---

## Moving around

<kbd>j</kbd> and <kbd>k</kbd> scroll, <kbd>J</kbd> and <kbd>K</kbd> turn pages, and <kbd>g</kbd><kbd>g</kbd> and <kbd>G</kbd> go to the first and last page. A number before a key repeats it, so <kbd>5</kbd><kbd>J</kbd> moves five pages. <kbd>Ctrl</kbd>-<kbd>g</kbd> asks for a page to go to, and `:page iv` goes to a page by its printed label.

Pages flow one after another by default. <kbd>m</kbd> switches to one page at a time and back. <kbd>d</kbd> shows spreads, with the first page standing alone as a cover. <kbd>c</kbd><kbd>o</kbd> toggles the cover, for books that start on a left-hand page.

Every jump is remembered: <kbd>Ctrl</kbd>-<kbd>o</kbd> goes back to where you were before it, and <kbd>Ctrl</kbd>-<kbd>i</kbd> goes forward again.

## Finding things

<kbd>/</kbd> searches forward and <kbd>?</kbd> backward. <kbd>n</kbd> and <kbd>N</kbd> move between matches, and <kbd>g</kbd><kbd>m</kbd> lists them all. Search ignores case. Modifiers, as in Vim, can go anywhere in the query:

```text
/\Cstone         match case
/\<moss\>        whole words only
/\vcolou?r       a Go regular expression from here on
/\%.pripple      this page only
```

<kbd>o</kbd> opens the outline, where you can type to filter it. <kbd>O</kbd> shows every page as a grid.

## Links

<kbd>F</kbd> labels every link on screen with a short hint. Type the hint to follow the link. Clicking works too. Internal links are jumps, so <kbd>Ctrl</kbd>-<kbd>o</kbd> brings you back.

## Marks and history

<kbd>"</kbd> followed by a letter marks the current place, and <kbd>'</kbd> followed by the same letter returns to it. Marks are kept per document, as is your place: closing a book and opening it next week puts you where you stopped. <kbd>g</kbd><kbd>r</kbd> lists recent files.

## Selecting, highlighting and notes

Drag to select text. <kbd>H</kbd> highlights the selection in a colour you pick. <kbd>x</kbd> deletes the annotation under the pointer, and right-click shows what else you can do with it. <kbd>u</kbd> and <kbd>U</kbd> undo and redo. While there are unsaved edits the status bar can show `[+]`. <kbd>Ctrl</kbd>-<kbd>s</kbd> (Cmd-S on macOS) or `:w` saves them into the PDF, so other viewers see them, and `:w copy.pdf` saves a copy instead.

## Presenting

<kbd>F5</kbd> starts presentation mode: one page at a time, filling the screen on a dark background.

## Help

<kbd>F1</kbd>, <kbd>g</kbd><kbd>?</kbd> or `:help` lists every command, key binding, search modifier and option. Choosing a row runs it or fills in the prompt, so help doubles as a launcher.
