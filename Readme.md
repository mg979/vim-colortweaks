# Colortweaks

<!-- vim-markdown-toc GFM -->

* [Introduction](#introduction)
* [Installation](#installation)
* [Commands](#commands)
* [Customization](#customization)
* [Cursorline](#cursorline)
* [Cursor shape/color](#cursor-shapecolor)
* [Example configuration](#example-configuration)

<!-- vim-markdown-toc -->

---

## Introduction

It allows customization of schemes without the need to alter the scheme itself.
It's nothing you couldn't do by changing them yourself, but this plugin will
do it automatically at every scheme switch, and apply your presets for that
scheme.

Properties you can define, among others:

* cursor color in normal/insert/replace mode
* line highlight color (different for insert/normal mode)
* line highlight presets for light/dark schemes
* alternate between the two last selected schemes
* invert background color
* rotate among a list of schemes
* further customizations for schemes
* can cooperate with [xolox/vim-colorscheme-switcher](https://github.com/xolox/vim-colorscheme-switcher)



---

## Installation

With [vim-plug](https://github.com/junegunn/vim-plug):

    `Plug 'mg979/vim-colortweaks'`


Note that by default it does nothing. You must set up the options.


---

## Commands

(*) If [xolox/vim-colorscheme-switcher](https://github.com/xolox/vim-colorscheme-switcher) is installed, its command will be run when switching schemes.

|Plug                               | Default     | Notes                     |
|-|-|-|
|`<Plug>ColorSwitch`                | `<leader>cs`  | alternate the last 2 schemes|
|`<Plug>RotatePrev`                 | `[cs`         |previous scheme in rotate list|
|`<Plug>RotateNext`                 | `]cs`         |next scheme in rotate list|
|`<Plug>ColorInvert`                | `<leader>ci`  | try to invert dark/light|
|`<Plug>ColorsList`                 | `<leader>C`   | custom fzf command|
|`<Plug>ColorPrev`                  | `[C`          | only with (*)|
|`<Plug>ColorNext`                  | `]C`          | only with (*)|

as `:colorscheme`, but applying tweaks:

    :Colorscheme <arg>


---

## Customization

You can set a number options to define different colorscheme properties and
behaviours.

First, initialize the dictionary

    let g:colortweaks = {}


Then add any of these keys:

|g:colortweaks.KEY               | Type |     Details                      |
|-|-|-|
|`default`                         | str  | color scheme to be loaded at startup |
|`default_alt`                     | str  | default alternate color scheme |
|`terminal_cursor`                 | bool | handle terminal cursor shape/color |
|`terminal_konsole`                | bool | same, using Konsole terminal |
|`colorscheme_rotate`              |  []  | colorscheme rotate list |

You can also define functions that will be called when switching to a
colorscheme, or anytime a colorscheme is switched.

```
    function! ColorTweaks_{colorscheme}()
    " stuff here
    endfunction

    function! ColorTweaks_all()
      " stuff here
    endfunction
```


---

## Cursorline

For the `CursorLine` highlight group there are special settings.

```
let g:colortweaks.dark_cursorline_presets       = ['guibg=#2d2d2d ctermbg=235', 'guibg=black ctermbg=16']
let g:colortweaks.dark_cursorline_for           = []
let g:colortweaks.dark_cursorline_custom        = {}
let g:colortweaks.light_cursorline_presets      = ['guibg=#d7d7af ctermbg=187', 'guibg=#dadada ctermbg=253']
let g:colortweaks.light_cursorline_for          = []
let g:colortweaks.light_cursorline_custom       = {}
```

- `presets`: for normal and insert mode
- `for`    : presets apply to the specified schemes. Empty by default!
- `custom` : if a scheme needs a custom `CursorLine`, it can be defined here ([normal, insert]).

Example:

```
    let g:colortweaks.dark_cursorline_custom = {
        \'nova': ['guibg=#4f616b ctermbg=236', 'guibg=#282c34 ctermbg=234'],
        \'onedark': ['guibg=#2c323c ctermbg=236', 'guibg=#1f2329 ctermbg=234'],
        \'zenburn': ['guibg=#555555 ctermbg=236', 'guibg=#1e1e1e ctermbg=234'],
        \'seoul256': ['guibg=#3f3f3f ctermbg=236', 'guibg=#2d2d2d ctermbg=234'],
        \}
```

---

## Cursor shape/color

To enable cursor shape/color in terminal, set:

    let g:colortweaks.terminal_cursor = 1

If you use Konsole terminal, set:

    let g:colortweaks.terminal_konsole = 1


Cursor shape/color presets:

```
    let g:colortweaks.cursor.normal   = {'color': 'green', 'shape': 'block', 'blink': 0}
    let g:colortweaks.cursor.insert   = {'color': 'orange', 'shape': 'vbar', 'blink': 1}
    let g:colortweaks.cursor.replace  = {'color': 'red', 'shape': 'hbar', 'blink': 1}
    let g:colortweaks.cursor.terminal = g:colortweaks.cursor.normal
```

`g:colortweaks.cursor.terminal` is used to restore cursor color on vim exit.


In neovim/gvim, there are the following additional settings (disabled by default):

```
    let g:colortweaks.cursor.command  = {'color': 'green', 'shape': 'block', 'blink': 1}
    let g:colortweaks.cursor.visual   = {'color': 'steelblue', 'shape': 'block', 'blink': 0}
```

---

## Example configuration

```
let g:colortweaks = {}
let g:colortweaks.default = CONF=='normal'? 'vsdark' : 'nova'
let g:colortweaks.default_alt = 'seoul256'
let g:colortweaks.terminal_cursor = 1
let g:colortweaks.gui_cursor = 1
let g:colortweaks.rotate = ['vsdark', 'nova', 'onedark', 'neodark', 'zenburn', 'seoul256', 'tomorrow_eighties']
let g:colortweaks.dark_cursorline_for = ['northpole', 'peaksea_dark', 'cobalt', 'wombat256mod', 'yowish', 'vsdark', 'desert']
let g:colortweaks.dark_cursorline_custom = {
      \'nova': ['guibg=#4f616b ctermbg=236', 'guibg=#282c34 ctermbg=234'],
      \'onedark': ['guibg=#2c323c ctermbg=236', 'guibg=#1f2329 ctermbg=234'],
      \'zenburn': ['guibg=#555555 ctermbg=236', 'guibg=#1e1e1e ctermbg=234'],
      \'seoul256': ['guibg=#3f3f3f ctermbg=236', 'guibg=#2d2d2d ctermbg=234'],
      \'cobalt': ['guibg=#1c1c1c ctermbg=236', 'guibg=#0c0c0c ctermbg=234'],
      \'space-vim-dark': ['guibg=#1c1c1c ctermbg=236', 'guibg=#0c0c0c ctermbg=234'],
      \}

let g:colortweaks.cursor_command = {'color': 'green', 'shape': 'block', 'blink': 1}
let g:colortweaks.cursor_visual  = {'color': 'steelblue', 'shape': 'block', 'blink': 0}
```

