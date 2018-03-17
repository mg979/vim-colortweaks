""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !exists('g:colortweaks_disable_mappings')
    if !hasmapto('<Plug>ColorNext')
        map <unique> ]cs <Plug>ColorNext
    endif
    if !hasmapto('<Plug>ColorPrev')
        map <unique> [cs <Plug>ColorPrev
    endif
    if !hasmapto('<Plug>RotateNext')
        map <unique> ]cr <Plug>RotateNext
    endif
    if !hasmapto('<Plug>RotatePrev')
        map <unique> [cr <Plug>RotatePrev
    endif
    if !hasmapto('<Plug>ColorSwitch')
        map <unique> <leader>cs <Plug>ColorSwitch
    endif
    if !hasmapto('<Plug>ColorInvert')
        map <unique> <leader>ci <Plug>ColorInvert
    endif
    if !hasmapto('<Plug>Colors')
        map <unique> <leader>C <Plug>Colors
    endif
endif

nnoremap <unique> <script> <Plug>Colors <SID>Colors
nnoremap <silent> <SID>Colors :Colors<cr>

nnoremap <unique> <script> <Plug>ColorSwitch <SID>ColorSwitch
nnoremap <silent> <SID>ColorSwitch :call colortweaks#color_switch()<cr>

nnoremap <unique> <script> <Plug>ColorInvert <SID>ColorInvert
nnoremap <silent> <SID>ColorInvert :call colortweaks#color_invert()<cr>:unsilent call colortweaks#check_invert()<cr>

nnoremap <unique> <script> <Plug>ColorNext <SID>ColorNext
nnoremap <silent> <SID>ColorNext :NextColorScheme<cr>:call colortweaks#color_tweaks()<cr>

nnoremap <unique> <script> <Plug>ColorPrev <SID>ColorPrev
nnoremap <silent> <SID>ColorPrev :PrevColorScheme<cr>:call colortweaks#color_tweaks()<cr>

nnoremap <unique> <script> <Plug>RotateNext <SID>RotateNext
nnoremap <silent> <SID>RotateNext :call colortweaks#rotate_next()<cr>:unsilent echo "Current color scheme: ".g:colors_name<cr>

nnoremap <unique> <script> <Plug>RotatePrev <SID>RotatePrev
nnoremap <silent> <SID>RotatePrev :call colortweaks#rotate_prev()<cr>:unsilent echo "Current color scheme: ".g:colors_name<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Initialize
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !exists('g:colorscheme_default')
    let g:colorscheme_default = 'default'
    let g:colors_name = 'default'
else
    let g:colors_name = g:colorscheme_default | endif

let g:colorscheme_default_alt    = get(g:, 'colorscheme_default_alt', 'desert')
let g:colortweaks_cursor_normal  = get(g:, 'colortweaks_cursor_normal', 'green')
let g:colortweaks_cursor_insert  = get(g:, 'colortweaks_cursor_insert', 'orange')
let g:colortweaks_cursor_replace = get(g:, 'colortweaks_cursor_replace', 'red')
let g:colortweaks_presets        = get(g:, 'colortweaks_presets', 1)
let g:dark_highlight_for         = get(g:, 'dark_highlight_for', [])
let g:light_highlight_for        = get(g:, 'light_highlight_for', [])
let g:colorscheme_rotate         = get(g:, 'colorscheme_rotate', [])
let g:custom_dark_highlight_for  = get(g:, 'custom_dark_highlight_for', {})
let g:custom_light_highlight_for = get(g:, 'custom_light_highlight_for', {})
let g:skip_highlight_for         = get(g:, 'skip_highlight_for', [])
let g:custom_colors_for          = get(g:, 'custom_colors_for', {})

if !exists('g:dark_highlight_presets')
    let g:dark_highlight_presets = ['guibg=#2d2d2d ctermbg=235', 'guibg=black ctermbg=black'] | endif

if !exists('g:light_highlight_presets')
    let g:light_highlight_presets = ['guibg=#d7d7af ctermbg=187', 'guibg=#d7d7af ctermbg=187'] | endif

call colortweaks#init()
call colortweaks#switch_to(g:colorscheme_default, 1)

command! -bang Colors call fzf#vim#colors({'sink': function('colortweaks#switch_to'), 'options': '--prompt "Colors >>>  "'}, <bang>0)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors in terminal mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if $COLORTERM == ( 'gnome-terminal' || 'rxvt-xpm' )
    set t_Co=256
endif

if &term =~ "xterm\\|rxvt"
    " cursor in insert mode
    let &t_SI = "\<Esc>]12;".g:colortweaks_cursor_insert."\x7"
    " cursor in replace mode
    let &t_SR = "\<Esc>]12;".g:colortweaks_cursor_replace."\x7"
    " cursor otherwise
    let &t_EI = "\<Esc>]12;".g:colortweaks_cursor_normal."\x7"
    silent !echo -ne "\033]12;".g:colortweaks_cursor_normal."\007"
    " reset cursor when vim exits
    autocmd VimLeave * silent !echo -ne "\033]112\007"
    " use \003]12;gray\007 for gnome-terminal
endif

