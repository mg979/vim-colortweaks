""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Schemes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#init()
  let s:color_index = index(g:colorscheme_rotate, g:colors_name)
  let s:last_colors_insert = colortweaks#highlight_color(1)
  let s:last_colors_normal = colortweaks#highlight_color(0)

  autocmd InsertEnter * execute "silent hi CursorLine ".colortweaks#mode(1)
  autocmd InsertLeave * execute "silent hi CursorLine ".colortweaks#mode(0)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#mode(insert)
  if a:insert | return s:last_colors_insert
  else | return s:last_colors_normal | endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#color_invert()
  let cs = g:colors_name
  if &background == 'dark' | let &background = 'light'
  else | let &background = 'dark' | endif
  if exists('g:colors_name')
    call colortweaks#color_tweaks() | let s:invert_ok = 1
  else
    call colortweaks#switch_to(cs) | let s:invert_ok = 0
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#check_invert()
  if s:invert_ok
    echo "Switched to ".&background." background."
  else
    let bg = &background == 'light' ? 'dark' : 'light'
    echo "No" bg "variant for this scheme."
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#rotate_cs()
  call colortweaks#switch_to(g:colorscheme_rotate[s:color_index])
  if g:colors_name == "PaperColor" | set background=dark | endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#rotate_next()
  let s:color_index += 1
  if s:color_index >= len(g:colorscheme_rotate) | let s:color_index = 0 | endif
  call colortweaks#rotate_cs()
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#rotate_prev()
  let s:color_index -= 1
  if s:color_index < 0 | let s:color_index = len(g:colorscheme_rotate)-1 | endif
  call colortweaks#rotate_cs()
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#switch_to(cs, ...)
  if !a:0 | let g:colorscheme_default_alt = get(g:, 'colors_name', g:colorscheme_default_alt) | endif
  if exists('g:loaded_colorscheme_switcher')
    call xolox#colorscheme_switcher#switch_to(a:cs)
  else
    " highlight clear
    exe "colorscheme" a:cs
  endif
  call colortweaks#color_tweaks()
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#color_switch()
  call colortweaks#switch_to(g:colorscheme_default_alt)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Line highlight
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:Fallback(mode)
  """Fallback for uncustomized schemes. Preset higlight is applied if it can be applied for the scheme.

  if &background == 'light' && index(g:light_highlight_for, g:colors_name) >= 0

    if a:mode | return g:light_highlight_presets[1]
    else | return g:light_highlight_presets[0] | endif

  elseif index(g:dark_highlight_for, g:colors_name) >= 0

    if a:mode | return g:dark_highlight_presets[1]
    else | return g:dark_highlight_presets[0] | endif

  else | return '' | endif      " no highlight
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#highlight_color(mode)
  """Define line highlight color."""

  if !empty(g:skip_highlight_for)
    if index(g:skip_highlight_for, g:colors_name) >= 0 | return '' | endif
  endif

  if &background == 'light' && has_key(g:custom_light_highlight_for, g:colors_name)
    let col = g:custom_light_highlight_for[g:colors_name]
  elseif has_key(g:custom_dark_highlight_for, g:colors_name)
    let col = g:custom_dark_highlight_for[g:colors_name]
  else
    return s:Fallback(a:mode)
  endif

  if a:mode | return col[1]
  else | return col[0] | endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#color_tweaks()

  " apply presets
  if g:colortweaks_presets
    highlight CursorLine cterm=NONE guifg=NONE ctermfg=NONE
    " highlight StatusLine guibg=#3e4452
  endif

  " define line higlight
  let s:last_colors_insert = colortweaks#highlight_color(1)
  let s:last_colors_normal = colortweaks#highlight_color(0)

  " apply normal mode
  silent execute "hi CursorLine " . s:last_colors_normal

  " further tweaks
  if has_key(g:custom_colors_for, g:colors_name)
    let col = g:custom_colors_for[g:colors_name]
    for prop in col | execute "hi ".prop | endfor
  endif

  if exists('*ColorTweaks_all')            | call ColorTweaks_all()                     | endif
  if exists('*ColorTweaks_'.g:colors_name) | exe "call ColorTweaks_".g:colors_name."()" | endif

  if exists('g:colors_name')
    " custom functions
    let s:color_index = index(g:colorscheme_rotate, g:colors_name)
  endif
endfunction

