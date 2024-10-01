---
title: "Marts Cheatsheet"
slug: "marts-cheatsheet"
date: 2024-09-30T16:42:32+02:00
publishdate: 2024-09-30T16:42:32+02:00
draft: true
author: ["Mart de Graaf"]
tags: ["Visual Studio", "Visual Studio Code", "Git Fork", "cheatsheet"]
summary: "Get the most out of tooling using Mart's cheatsheet."
# Toc
ShowToc: true
TocOpen: true
UseHugoToc: false

# Meta settings
ShowReadingTime: true
ShowLastModified: true
ShowWordCount: true

cover:
    image: "trinity-college-library-5174182_1280.jpg" # image path/url
    alt: "Trinity college library, Dublin, Image from marouh via Pixabay" # alt text
    caption: "Trinity college library, Dublin, Image from marouh via Pixabay" # display caption under cover
    relative: true # when using page bundles set this to true
    hidden: false # only hide on current single page
---


## Visual Studio Code

| Command | Description |
| --- | --- |
| `Ctrl + Shift + P` or `F1` | Open command palette |
| `Ctrl + i` | Open GitHub Copilot inline |
| `Ctrl + Shift + i` | Open GitHub Copilot |
| `F2` | Rename variables and methods |
| `Alt + Shift + F` | Format document |
| `Ctrl + /` | Comment out code |
| `Ctrl + Shift + O` | Remove unused usings |

If you want a one-page cheatsheet, check [https://code.visualstudio.com/shortcuts/keyboard-shortcuts-windows.pdf](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-windows.pdf).

## Visual Studio

| Command | Description |
| --- | --- |
| `Ctrl + Q` | Visual Studio search |
| `Ctrl + -` <br> `Ctrl + Shift -` | Navigating Backward <br> Navigating Forward |
| `Alt + /` | Open GitHub Copilot |
| `Ctrl + R, Ctrl + R` | Rename variables and methods |
| `Ctrl + K, Ctrl + D` | Format document |
| `Ctrl + K, Ctrl + C` <br> `Ctrl + K, Ctrl + U` | Comment out code <br> Uncomment code |
| `Ctrl + R, Ctrl + G` | Remove and sort usings |

If you want all from Microsoft, check their cheatsheet for Visual Studio at [https://visualstudio.microsoft.com/keyboard-shortcuts.pdf](https://visualstudio.microsoft.com/keyboard-shortcuts.pdf).

## Git Fork

I am frequently using Git Fork. Here are some commands I think help me be more productive.

| Command | Description |
| --- | --- |
| `Ctrl + P` | Show Quick launch window |
| `Ctrl + Enter` | Commit |
| `Ctrl + Shift + Enter` | Commit and push |
| `Ctrl + Tab / Shift Tab` | Next tab / previous tab |
| `Ctrl + Shift + B` | New branch |
| `Ctrl + Shift + T`  | New tag |
| `Ctrl + Shift + H`  | Create stash |

## Windows

I am frequently using Git Fork. Here are some commands I think help me be more productive.

| Command | Description |
| --- | --- |
| `Windows + L` | Windows lunch, lock your PC when you 're away. |
| `Windows + Shift + S` | Screenshot via snipping tool |
| `Windows + Shift + R` | Video snip via snipping tool |
| `Windows + Plus (+)` | Zoom in using magnifier |

See all the shortcuts at [https://github.com/fork-dev/TrackerWin/issues/333](https://github.com/fork-dev/TrackerWin/issues/333).

## Git

Fix an casing issue in your files.
```bash 
git mv --force address.cs Address.cs
git mv --force <old_file> <new_file>
```

Creating an annotated tag using the `-a` flag.
```bash
git tag -a v1.4 -m "my version 1.4"
```

## NPM

Update multiple packages at once using the scope.

```bash
npx update-by-scope "@angular"
```
