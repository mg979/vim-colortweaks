"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Initialize
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
let g:colortweaks.light_cursorline_presets      = get(g:colortweaks, 'light_cursorline_presets', ['guibg=#dfdfdf ctermbg=188', 'guibg=#dadada ctermbg=253'])
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
  endif
  command! -nargs=? -complete=color Colorscheme call colortweaks#switch_to(empty(<q-args>) ? g:colortweaks.default : <q-args>)
endfun




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <Plug>ColorsList      :Colors<cr>
nnoremap <silent> <Plug>ColorSwitch     :call colortweaks#color_switch()<cr>
nnoremap <silent> <Plug>ColorInvert     :call colortweaks#color_invert()<cr>:unsilent call colortweaks#check_invert()<cr>
nnoremap <silent> <Plug>ColorRotateNext :call colortweaks#rotate_next()<cr>:unsilent echo "Current color scheme: ".g:colors_name<cr>
nnoremap <silent> <Plug>ColorRotatePrev :call colortweaks#rotate_prev()<cr>:unsilent echo "Current color scheme: ".g:colors_name<cr>

if !get(g:colortweaks, 'mappings', 1)
  finish
endif

fun! s:mapkeys(keys, plug)
  let plug = '<Plug>Color'.a:plug
  if maparg(a:keys, 'n') == '' && !hasmapto(plug)
    silent! execute 'nmap <unique>' a:keys plug
  endif
endfun

call s:mapkeys(']C', 'RotateNext')
call s:mapkeys('[C', 'RotatePrev')
call s:mapkeys('<leader>cs', 'Switch')
call s:mapkeys('<leader>ci', 'Invert')
call s:mapkeys('<leader>C', 'sList')
