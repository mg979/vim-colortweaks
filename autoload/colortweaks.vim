""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Schemes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:color_index = index(g:colortweaks.rotate, g:colors_name)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#color_invert()
  let cs = g:colors_name
  if &background == 'dark' | let &background = 'light'
  else | let &background = 'dark' | endif
  if exists('g:colors_name')
    call colortweaks#apply() | let s:invert_ok = 1
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
  call colortweaks#switch_to(g:colortweaks.rotate[s:color_index])
  if g:colors_name == "PaperColor" | set background=dark | endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#rotate_next()
  if empty(g:colortweaks.rotate) | return | endif
  let s:color_index += 1
  if s:color_index >= len(g:colortweaks.rotate) | let s:color_index = 0 | endif
  call colortweaks#rotate_cs()
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#rotate_prev()
  if empty(g:colortweaks.rotate) | return | endif
  let s:color_index -= 1
  if s:color_index < 0 | let s:color_index = len(g:colortweaks.rotate)-1 | endif
  call colortweaks#rotate_cs()
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#switch_to(cs, ...)
  let g:colortweaks.default_alt = get(g:, 'colors_name', g:colortweaks.default_alt)
  if !a:0
    if exists('g:loaded_colorscheme_switcher')
      call xolox#colorscheme_switcher#switch_to(a:cs)
    else
      exe "colorscheme" a:cs
    endif
  endif
  call colortweaks#apply()
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#color_switch()
  call colortweaks#switch_to(g:colortweaks.default_alt)
endfunction




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#apply()
  let G = g:colortweaks

  " apply CursorLine if defined for scheme
  call colortweaks#cursor_line(0)

  " custom functions
  if exists('*ColorTweaks_all')
    call ColorTweaks_all()
  endif
  if exists('*ColorTweaks_'.g:colors_name)
    call ColorTweaks_{g:colors_name}()
  endif

  if g:colortweaks.cursor.gui
    call colortweaks#cursor#gui()
  endif
  let s:color_index = index(G.rotate, g:colors_name)
endfunction




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CursorLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#cursor_line(insert) abort
  """Apply CursorLine highlight if defined.
  let G = g:colortweaks

  let custom_light     = has_key(G.light_cursorline_custom,  g:colors_name)
  let custom_dark      = has_key(G.dark_cursorline_custom,   g:colors_name)
  let use_light_preset = index(G.light_cursorline_for, g:colors_name) >= 0
  let use_dark_preset  = index(G.dark_cursorline_for,  g:colors_name) >= 0

  if &background == 'light' && custom_light
    let col = G.light_cursorline_custom[g:colors_name]

  elseif &background == 'light' && use_light_preset
    let col = G.light_cursorline_presets

  elseif custom_dark
    let col = G.dark_cursorline_custom[g:colors_name]

  elseif use_dark_preset
    let col = G.dark_cursorline_presets

  else
    return
  endif

  if a:insert   | exe "hi CursorLine" col[1]
  else          | exe "hi CursorLine" col[0]
  endif
endfunction





