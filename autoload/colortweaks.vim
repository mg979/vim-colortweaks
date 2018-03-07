function! colortweaks#fzf(cs)
  call xolox#colorscheme_switcher#switch_to(a:cs)
  if a:cs == "PaperColor" | set background=dark | endif
  call ColorTweaks()
endfunction
