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

nnoremap <silent> <Plug>ColorsList      :Colors<cr>
nnoremap <silent> <Plug>ColorSwitch     :call colortweaks#color_switch()<cr>
nnoremap <silent> <Plug>ColorInvert     :call colortweaks#color_invert()<cr>:unsilent call colortweaks#check_invert()<cr>
nnoremap <silent> <Plug>ColorRotateNext :call colortweaks#rotate_next()<cr>:unsilent echo "Current color scheme: ".g:colors_name<cr>
nnoremap <silent> <Plug>ColorRotatePrev :call colortweaks#rotate_prev()<cr>:unsilent echo "Current color scheme: ".g:colors_name<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Initialize
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:colortweaks = get(g:, 'colortweaks', {})

let g:colortweaks.rotate                        = get(g:colortweaks, 'rotate', [])
let g:colortweaks.custom_colors                 = get(g:colortweaks, 'custom_colors', {})
let g:colortweaks.generic_presets               = get(g:colortweaks, 'generic_presets', 1)
let g:colortweaks.guicursor                     = has('gui_running') || has('nvim') ? get(g:colortweaks, 'guicursor', 1) : 0

let g:colortweaks.cursor_normal                 = get(g:colortweaks, 'cursor_normal', {'color': 'green', 'shape': 'block', 'blink': 0})
let g:colortweaks.cursor_insert                 = get(g:colortweaks, 'cursor_insert', {'color': 'orange', 'shape': 'ver', 'blink': 1})
let g:colortweaks.cursor_replace                = get(g:colortweaks, 'cursor_replace', {'color': 'red', 'shape': 'hor', 'blink': 1})
let g:colortweaks.cursor_command                = get(g:colortweaks, 'cursor_command', {})
let g:colortweaks.cursor_visual                 = get(g:colortweaks, 'cursor_visual', {})
let g:colortweaks.cursor_terminal               = get(g:colortweaks, 'cursor_terminal', g:colortweaks.cursor_normal)

let g:colortweaks.dark_cursorline_presets       = get(g:colortweaks, 'dark_cursorline_presets', ['guibg=#2d2d2d ctermbg=235', 'guibg=#121212 ctermbg=233'])
let g:colortweaks.dark_cursorline_for           = get(g:colortweaks, 'dark_cursorline_for', ['desert', 'slate'])
let g:colortweaks.dark_cursorline_custom        = get(g:colortweaks, 'dark_cursorline_custom', {})
let g:colortweaks.light_cursorline_presets      = get(g:colortweaks, 'light_cursorline_presets', ['guibg=#dfdfdf ctermbg=188', 'guibg=#dadada ctermbg=253'])
let g:colortweaks.light_cursorline_for          = get(g:colortweaks, 'light_cursorline_for', [])
let g:colortweaks.light_cursorline_custom       = get(g:colortweaks, 'light_cursorline_custom', {})

command! -bang Colors call fzf#vim#colors({'sink': function('colortweaks#switch_to'), 'options': '--prompt "Colors >>>  "'}, <bang>0)
command! -nargs=? -complete=color Colorscheme call colortweaks#switch_to(empty(<q-args>) ? g:colortweaks.default : <q-args>)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VimEnter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

au VimEnter * call s:VimEnter()

function! s:VimEnter()
  if exists('g:loaded_colorscheme_switcher')
    call s:mapkeys(']C', 'Next')
    call s:mapkeys('[C', 'Prev')
    nnoremap <silent> <Plug>ColorNext :NextColorScheme<cr>:call colortweaks#apply()<cr>
    nnoremap <silent> <Plug>ColorPrev :PrevColorScheme<cr>:call colortweaks#apply()<cr>
  endif

  let g:colortweaks.default = get(g:colortweaks, 'default', exists('g:colors_name') ? g:colors_name : 'desert')
  let alt = get(g:colortweaks, 'default_alt', 'desert')
  let g:colors_name = g:colortweaks.default

  call colortweaks#init()
  call colortweaks#switch_to(g:colortweaks.default)
  let g:colortweaks.default_alt = alt
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cursor shape/color
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:cursorShape(mode, gui)
  let C = eval('g:colortweaks.cursor_'.a:mode)
  let C = empty(C) ? eval('g:colortweaks.cursor_normal') : C

  if !a:gui
    let n = C.shape == 'block' ? 2 : C.shape == 'ver' ? 6 : 4
    return C.blink ? n-1 : n
  else
    let shape = C.shape=='block' ? C.shape : C.shape."10"
    let blink = C.blink ? '-blinkwait700-blinkoff400-blinkon250' : '-blinkon0'
    return [shape, blink]
  endif
endfun

if g:colortweaks.guicursor
  call colortweaks#guicursor()
  let [shape, blink] = s:cursorShape('normal', 1)
  let &guicursor = "n:".shape.'-Cursor'.blink
  let [shape, blink] = s:cursorShape('insert', 1)
  let &guicursor = "i:".shape.'-iCursor'.blink
  let [shape, blink] = s:cursorShape('replace', 1)
  let &guicursor = "r:".shape.'-rCursor'.blink
  let [shape, blink] = s:cursorShape('command', 1)
  let &guicursor = "c:".shape.'-cCursor'.blink
  let [shape, blink] = s:cursorShape('visual', 1)
  let &guicursor = "v:".shape.'-vCursor'.blink
  finish
endif

if get(g:colortweaks, 'terminal_konsole', 0)
  set termguicolors
  autocmd VimEnter * silent !konsoleprofile UseCustomCursorColor=1
  let &t_EI = "\<Esc>]50;CursorShape=0;CustomCursorColor=green;BlinkingCursorEnabled=0\x7"
  let &t_SI = "\<Esc>]50;CursorShape=1;CustomCursorColor=orange;BlinkingCursorEnabled=1\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2;CustomCursorColor=red;BlinkingCursorEnabled=1\x7"
  silent !konsoleprofile CustomCursorColor=green
  autocmd VimLeave * silent !konsoleprofile CustomCursorColor=gray;BlinkingCursorEnabled=0

elseif get(g:colortweaks, 'terminal_cursor', 0) && &term =~ "xterm\\|rxvt"
  let N = g:colortweaks.cursor_normal
  let I = g:colortweaks.cursor_insert
  let R = g:colortweaks.cursor_replace
  let T = g:colortweaks.cursor_terminal
  " cursor in insert mode
  let &t_SI = "\033[".s:cursorShape('insert', 0)." q\<Esc>]12;".I.color."\x7"
  " cursor in replace mode
  let &t_SR = "\033[".s:cursorShape('replace', 0)." q\<Esc>]12;".R.color."\x7"
  " cursor otherwise
  let &t_EI = "\033[".s:cursorShape('normal', 0)." q\<Esc>]12;".N.color."\x7"
endif
