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
    if !hasmapto('<Plug>ColorInvert')
        map <unique> <leader>cs <Plug>ColorInvert
    endif
    if !hasmapto('<Plug>Colors')
        map <unique> <leader>C <Plug>Colors
    endif
endif

nnoremap <unique> <script> <Plug>Colors <SID>Colors
nnoremap <SID>Colors :Colors<cr>

nnoremap <unique> <script> <Plug>ColorInvert <SID>ColorInvert
nnoremap <SID>ColorInvert :call <SID>ColorInvert()<cr>

nnoremap <unique> <script> <Plug>ColorNext <SID>ColorNext
nnoremap <silent> <SID>ColorNext :NextColorScheme<cr>:call ColorTweaks()<cr>

nnoremap <unique> <script> <Plug>ColorPrev <SID>ColorPrev
nnoremap <silent> <SID>ColorPrev :PrevColorScheme<cr>:call ColorTweaks()<cr>

nnoremap <unique> <script> <Plug>RotateNext <SID>RotateNext
nnoremap <silent> <SID>RotateNext :call <SID>RotateNext()<cr>:unsilent echo "Current color scheme: ".g:colors_name<cr>

nnoremap <unique> <script> <Plug>RotatePrev <SID>RotatePrev
nnoremap <silent> <SID>RotatePrev :call <SID>RotatePrev()<cr>:unsilent echo "Current color scheme: ".g:colors_name<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Schemes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! <SID>ColorInvert()
    let cs = g:colors_name
    if &background == 'dark' | set background=light
    else | set background=dark | endif
    if exists('g:colors_name')
        call ColorTweaks()
        echo "Switched to ".&background." background."
    else
        if &background == 'dark' | set background=light
        else | set background=dark | endif
        call xolox#colorscheme_switcher#switch_to(cs)
        echo "No ".&background." variant for this scheme."
    endif
endfunction

function! <SID>RotateCS()
    call xolox#colorscheme_switcher#switch_to(g:colorscheme_rotate[s:color_index])
    if g:colors_name == "PaperColor" | set background=dark | endif
    call ColorTweaks()
endfunction

function! <SID>RotateNext()
    let s:color_index += 1
    if s:color_index >= len(g:colorscheme_rotate) | let s:color_index = 0 | endif
    call <SID>RotateCS()
endfunction

function! <SID>RotatePrev()
    let s:color_index -= 1
    if s:color_index < 0 | let s:color_index = len(g:colorscheme_rotate)-1 | endif
    call <SID>RotateCS()
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Line highlight
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function s:Fallback(mode)
    """Fallback for uncustomized schemes. Preset higlight is applied if it can
    """be applied for the scheme.

    if &background == 'light' && index(g:light_highlight_for, g:colors_name) >= 0

        if a:mode | return g:light_highlight_presets[1]
        else | return g:light_highlight_presets[0] | endif

    elseif index(g:dark_highlight_for, g:colors_name) >= 0

        if a:mode | return g:dark_highlight_presets[1]
        else | return g:dark_highlight_presets[0] | endif

    else | return '' | endif
        " no highlight
endfunction

function! <SID>HighlightColor(mode)
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

function! ColorTweaks()

    " apply presets
    if g:colortweaks_presets
        highlight CursorLine cterm=NONE guifg=NONE ctermfg=NONE
        highlight StatusLine guibg=#3e4452
    endif

    " define line higlight
    let s:last_colors_insert = <SID>HighlightColor(1)
    let s:last_colors_normal = <SID>HighlightColor(0)

    " apply normal mode
    silent execute "hi CursorLine " . s:last_colors_normal

    " further tweaks
    if has_key(g:custom_colors_for, g:colors_name)
        let col = g:custom_colors_for[g:colors_name]
        for prop in col | execute "hi ".prop | endfor
    endif

    if exists(g:colors_name)
        let s:color_index = index(g:colorscheme_rotate, g:colors_name) | endif

endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Initialize
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !exists('g:colorscheme_default')
    let g:colorscheme_default = 'default'
    let g:colors_name = 'default'
else
    let g:colors_name = g:colorscheme_default | endif

if !exists('g:colortweaks_cursor_normal')
    let g:colortweaks_cursor_normal = 'green' | endif

if !exists('g:colortweaks_cursor_insert')
    let g:colortweaks_cursor_insert = 'orange' | endif

if !exists('g:colortweaks_cursor_replace')
    let g:colortweaks_cursor_replace = 'red' | endif

if !exists('g:colortweaks_presets')
    let g:colortweaks_presets = 1 | endif

if !exists('g:dark_highlight_for')
    let g:dark_highlight_for = [] | endif

if !exists('g:light_highlight_for')
    let g:light_highlight_for = [] | endif

if !exists('g:colorscheme_rotate')
    let g:colorscheme_rotate = [] | endif

if !exists('g:custom_dark_highlight_for')
    let g:custom_dark_highlight_for = {} | endif

if !exists('g:custom_light_highlight_for')
    let g:custom_light_highlight_for = {} | endif

if !exists('g:dark_highlight_presets')
    let g:dark_highlight_presets = ['guibg=#2d2d2d ctermbg=235', 'guibg=black ctermbg=black'] | endif

if !exists('g:light_highlight_presets')
    let g:light_highlight_presets = ['guibg=#d7d7af ctermbg=187', 'guibg=#d7d7af ctermbg=187'] | endif

if !exists('g:skip_highlight_for')
    let g:skip_highlight_for = [] | endif

if !exists('g:custom_colors_for')
    let g:custom_colors_for = {} | endif

let s:color_index = index(g:colorscheme_rotate, g:colors_name)
let s:last_colors_insert = <SID>HighlightColor(1)
let s:last_colors_normal = <SID>HighlightColor(0)

call xolox#colorscheme_switcher#switch_to(g:colorscheme_default)
call ColorTweaks()

autocmd InsertEnter * execute "silent hi CursorLine ".s:last_colors_insert
autocmd InsertLeave * execute "silent hi CursorLine ".s:last_colors_normal
command! -bang Colors call fzf#vim#colors({'sink': function('colortweaks#fzf'), 'options': '--reverse'}, <bang>0)

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



