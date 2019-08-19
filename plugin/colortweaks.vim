"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Initialize
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists('g:loaded_colortweaks')
  finish
endif
let g:loaded_colortweaks = 1

let g:colortweaks = get(g:, 'colortweaks', {})

let g:colortweaks.rotate                        = get(g:colortweaks, 'rotate', [])
let g:colortweaks.cursor                        = get(g:colortweaks, 'cursor', {'gui': has('gui_running') || has('nvim'), 'terminal': 0, 'konsole': 0})

let g:colortweaks.cursor.normal                 = get(g:colortweaks.cursor, 'normal', {'color': 'green', 'shape': 'block', 'blink': 0})
let g:colortweaks.cursor.insert                 = get(g:colortweaks.cursor, 'insert', {'color': 'orange', 'shape': 'ver', 'blink': 1})
let g:colortweaks.cursor.replace                = get(g:colortweaks.cursor, 'replace', {'color': 'red', 'shape': 'hor', 'blink': 1})
let g:colortweaks.cursor.command                = get(g:colortweaks.cursor, 'command', {})
let g:colortweaks.cursor.visual                 = get(g:colortweaks.cursor, 'visual', {})

let g:colortweaks.dark_cursorline_presets       = get(g:colortweaks, 'dark_cursorline_presets', ['guibg=#2d2d2d ctermbg=235', 'guibg=#121212 ctermbg=233'])
let g:colortweaks.dark_cursorline_for           = get(g:colortweaks, 'dark_cursorline_for', ['desert', 'slate'])
let g:colortweaks.dark_cursorline_custom        = get(g:colortweaks, 'dark_cursorline_custom', {})
let g:colortweaks.light_cursorline_presets      = get(g:colortweaks, 'light_cursorline_presets', ['guibg=#aaaaaa ctermbg=248', 'guibg=#c6c6c6 ctermbg=251'])
let g:colortweaks.light_cursorline_for          = get(g:colortweaks, 'light_cursorline_for', [])
let g:colortweaks.light_cursorline_custom       = get(g:colortweaks, 'light_cursorline_custom', {})

let g:colortweaks.default = get(g:colortweaks, 'default', exists('g:colors_name') ? g:colors_name : 'default')
let g:colortweaks.default_alt = get(g:colortweaks, 'default_alt', 'desert')




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup colortweaks
  au!
  autocmd InsertEnter * call colortweaks#cursor_line(1)
  autocmd InsertLeave * call colortweaks#cursor_line(0)
  autocmd VimEnter    * call s:VimEnter()
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:VimEnter()
  if g:colortweaks.cursor.gui || g:colortweaks.cursor.terminal || g:colortweaks.cursor.konsole
    call colortweaks#cursor#init()
  endif

  if get(g:, 'loaded_fzf', 0)
    command! -bang Colors call fzf#vim#colors({'sink': function('colortweaks#switch_to'), 'options': '--prompt "Colors >>>  "'}, <bang>0)
    if get(g:colortweaks, 'mappings', 1)
      call s:mapkeys('<leader>C', 's')
    endif
  endif
endfun




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! -nargs=? -complete=color ColorTheme call colortweaks#switch_to(empty(<q-args>) ? g:colortweaks.default : <q-args>)

command! ColorAlt        call colortweaks#color_alternate()
command! ColorInvert     call colortweaks#color_invert()
command! ColorRotateNext call colortweaks#rotate_next()
command! ColorRotatePrev call colortweaks#rotate_prev()

if !get(g:colortweaks, 'mappings', 1)
  finish
endif

fun! s:mapkeys(keys, cmd)
  let cmd = printf(':Color%s<cr>', a:cmd)
  if maparg(a:keys, 'n') == ''
    silent! execute 'nnoremap <silent>' a:keys cmd
  endif
endfun

call s:mapkeys(']C', 'RotateNext')
call s:mapkeys('[C', 'RotatePrev')
call s:mapkeys('<leader>cs', 'Alt')
call s:mapkeys('<leader>ci', 'Invert')
