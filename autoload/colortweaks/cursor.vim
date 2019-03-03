""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cursor shape/color
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:cursor_shape(mode, gui) abort
  let C = g:colortweaks.cursor[a:mode]
  let C = empty(C) ? g:colortweaks.cursor.normal : C

  if !a:gui
    let n = C.shape == 'block' ? 2 : C.shape == 'ver' ? 6 : 4
    return C.blink ? n-1 : n
  else
    let shape = C.shape=='block' ? C.shape : C.shape."10"
    let blink = C.blink ? '-blinkwait700-blinkoff400-blinkon250' : '-blinkon0'
    return [shape, blink]
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! colortweaks#cursor#gui() abort
  if has('gui_running') || has('nvim')
    let C = g:colortweaks.cursor
    exe "hi iCursor guifg=NONE guibg=".C.insert.color
    exe "hi rCursor guifg=NONE guibg=".C.replace.color
    if !empty(C.visual)  | exe "hi vCursor guifg=white guibg=".C.visual.color
    else                 | hi! link vCursor Cursor
    endif
    if !empty(C.command) | exe "hi cCursor guifg=white guibg=".C.command.color
    else                 | hi! link cCursor Cursor
    endif
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! colortweaks#cursor#init() abort

  if g:colortweaks.cursor.gui
    call colortweaks#cursor#gui()
    let [shape, blink] = s:cursor_shape('normal', 1)
    let &guicursor = "n:".shape.'-Cursor'.blink
    let [shape, blink] = s:cursor_shape('insert', 1)
    let &guicursor = "i:".shape.'-iCursor'.blink
    let [shape, blink] = s:cursor_shape('replace', 1)
    let &guicursor = "r:".shape.'-rCursor'.blink
    let [shape, blink] = s:cursor_shape('command', 1)
    let &guicursor = "c:".shape.'-cCursor'.blink
    let [shape, blink] = s:cursor_shape('visual', 1)
    let &guicursor = "v:".shape.'-vCursor'.blink
    return
  endif

  if g:colortweaks.cursor.konsole
    set termguicolors
    autocmd VimEnter * silent !konsoleprofile UseCustomCursorColor=1
    let &t_EI = "\<Esc>]50;CursorShape=0;CustomCursorColor=green;BlinkingCursorEnabled=0\x7"
    let &t_SI = "\<Esc>]50;CursorShape=1;CustomCursorColor=orange;BlinkingCursorEnabled=1\x7"
    let &t_SR = "\<Esc>]50;CursorShape=2;CustomCursorColor=red;BlinkingCursorEnabled=1\x7"
    silent !konsoleprofile CustomCursorColor=green
    autocmd VimLeave * silent !konsoleprofile CustomCursorColor=gray;BlinkingCursorEnabled=0

  elseif g:colortweaks.cursor.terminal && &term =~ "xterm\\|rxvt"
    let N = g:colortweaks.cursor.normal
    let I = g:colortweaks.cursor.insert
    let R = g:colortweaks.cursor.replace
    " cursor in insert mode
    let &t_SI = "\033[".s:cursor_shape('insert', 0)." q\<Esc>]12;".I.color."\x7"
    " cursor in replace mode
    let &t_SR = "\033[".s:cursor_shape('replace', 0)." q\<Esc>]12;".R.color."\x7"
    " cursor otherwise
    let &t_EI = "\033[".s:cursor_shape('normal', 0)." q\<Esc>]12;".N.color."\x7"
  endif
endfun

