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
    call colortweaks#apply()
    redraw
    echo "Switched to ".&background." background."
  else
    call colortweaks#switch_to(cs)
    let bg = &background == 'light' ? 'dark' : 'light'
    echo "No" bg "variant for this scheme."
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#rotate_cs()
  call colortweaks#switch_to(g:colortweaks.rotate[s:color_index])
  redraw
  echo "Current color scheme: ".g:colors_name
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#color_alternate()
  call colortweaks#switch_to(g:colortweaks.default_alt)
  redraw
  echo "Current color scheme: ".g:colors_name
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

  if custom_light && &background == 'light'
    let col = G.light_cursorline_custom[g:colors_name]

  elseif use_light_preset && &background == 'light'
    let col = G.light_cursorline_presets

  elseif custom_dark && &background == 'dark'
    let col = G.dark_cursorline_custom[g:colors_name]

  elseif use_dark_preset && &background == 'dark'
    let col = G.dark_cursorline_presets

  else
    return
  endif

  exe "hi CursorLine ".col[a:insert]
endfunction





