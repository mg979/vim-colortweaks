""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Schemes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#init()
  let s:color_index = index(g:colortweaks.rotate, g:colors_name)
  let s:last_colors_insert = colortweaks#cursorline_color(1)
  let s:last_colors_normal = colortweaks#cursorline_color(0)

  augroup colortweaks-cursor
    au!
    autocmd InsertEnter * call colortweaks#cursorline(1)
    autocmd InsertLeave * call colortweaks#cursorline(0)
  augroup END
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#cursorline(insert)
  if a:insert   | execute "silent hi CursorLine" s:last_colors_insert
  else          | execute "silent hi CursorLine " s:last_colors_normal
  endif
endfunction

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
" Line highlight
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:Presets(normal)
  """Preset highlight is applied if it can be applied for the scheme.
  let G = g:colortweaks

  if &background == 'light' && index(G.light_cursorline_for, g:colors_name) >= 0

    if a:normal | return G.light_cursorline_presets[1]
    else        | return G.light_cursorline_presets[0] | endif

  elseif index(G.dark_cursorline_for, g:colors_name) >= 0

    if a:normal | return G.dark_cursorline_presets[1]
    else        | return G.dark_cursorline_presets[0] | endif

  else          | return '' | endif      " no highlight
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#cursorline_color(normal)
  """Define line highlight color.
  let G = g:colortweaks | let scheme = g:colors_name

  if &background == 'light' && has_key(G.light_cursorline_custom, scheme)
    let col = G.light_cursorline_custom[scheme]

  elseif has_key(G.dark_cursorline_custom, scheme)
    let col = G.dark_cursorline_custom[scheme]

  else
    return s:Presets(a:normal)
  endif

  if a:normal   | return col[1]
  else          | return col[0] | endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#apply()
  let G = g:colortweaks

  " apply presets
  if G.generic_presets
    highlight! CursorLine cterm=NONE guifg=NONE ctermfg=NONE
  endif

  " define line higlight
  let s:last_colors_insert = colortweaks#cursorline_color(1)
  let s:last_colors_normal = colortweaks#cursorline_color(0)

  " apply normal mode
  silent execute "hi CursorLine " . s:last_colors_normal

  " further tweaks
  if has_key(G.custom_colors, g:colors_name)
    let col = G.custom_colors[g:colors_name]
    for prop in col | execute prop | endfor
  endif

  " custom functions
  if exists('*ColorTweaks_all')            | call ColorTweaks_all()                     | endif
  if exists('*ColorTweaks_'.g:colors_name) | exe "call ColorTweaks_".g:colors_name."()" | endif

  if g:colortweaks.guicursor | call colortweaks#guicursor() | endif
  let s:color_index = index(G.rotate, g:colors_name)
endfunction

function! colortweaks#guicursor()
  if has('gui_running') || has('nvim')
    let C = g:colortweaks
    exe "hi iCursor guifg=NONE guibg=".C.cursor_insert.color
    exe "hi rCursor guifg=NONE guibg=".C.cursor_replace.color
    if !empty(C.cursor_visual)  | exe "hi vCursor guifg=white guibg=".C.cursor_visual.color
    else                        | hi! link vCursor Cursor
    endif
    if !empty(C.cursor_command) | exe "hi cCursor guifg=white guibg=".C.cursor_command.color
    else                        | hi! link cCursor Cursor
    endif
  endif
endfunction
