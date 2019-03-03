# Colortweaks

<!-- vim-markdown-toc GFM -->

* [Introduction](#introduction)
* [Installation](#installation)
* [Commands](#commands)
* [Customization](#customization)

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

|Plug                     | Default     | Notes                     |
|-|-|-|
|`<Plug>ColorRotatePrev`  | `[C`          | previous scheme in rotate list|
|`<Plug>ColorRotateNext`  | `]C`          | next scheme in rotate list|
|`<Plug>ColorSwitch`      | `<leader>cs`  | alternate the last 2 schemes|
|`<Plug>ColorInvert`      | `<leader>ci`  | try to invert dark/light|
|`<Plug>ColorsList`       | `<leader>C`   | custom fzf command|

as `:colorscheme`, but applying tweaks:

    :Colorscheme <name>


---

## Customization

`:help colortweaks`

