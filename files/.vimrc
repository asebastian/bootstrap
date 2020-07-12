" Enable pathogen
filetype off
call pathogen#infect()

" Fix weird encoding issue on arch
set encoding=utf-8

" Make helptags for current plugin bundle
:Helptags

" Set ctags path
:set tags=tags;./tags,./gems.tags;

" Remove trailing whitespace on write
autocmd BufWritePre * :%s/\s\+$//e

" Use system clipboard by default (OSX/Windows, linux untested)
set clipboard^=unnamed

" Use nifty vim stuff
set nocompatible

" For protection
set modelines=0

" Key timeout length
set timeout timeoutlen=5000 ttimeoutlen=100

" Filetype-specific indentation
filetype plugin indent on

" Recognize .erb files as eruby
autocmd BufRead,BufNewFile *.erb set filetype=eruby.html

" Disable vim autocommenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Set indentation for javascript to two spaces
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2

" Disable vim parenthesis highlighting
let g:loaded_matchparen=1

" Set 100ms updatetime, so gitgutter is not slow
set updatetime=100

" Basic styles: line numbers, syntax highlighting, 256 colors for colorschemes to work
set nu
syntax on
set t_Co=256
set cursorline
set smartindent

" Only show cursorline in current window
augroup cline
  au!
  au WinLeave * set nocursorline
  au WinEnter * set cursorline
  au InsertEnter * set nocursorline
  au InsertLeave * set cursorline
augroup END

" Statusbar
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" fonts
" colorscheme lucius
" colorscheme Tomorrow-Night-Eighties
colorscheme zenburn
let g:airline_powerline_fonts = 1

" tab completion
set wildmode=longest,list,full
set wildmenu

" Longer history
set history=10000

" Tabs set @ 2, use spaces instead of tabs
set ts=2 sts=2 sw=2 expandtab
" filetype specific tabs
" au BufEnter *.js setlocal ts=4 sts=4 sw=4 expandtab

" Delete previous word with Ctrl-Backspace
imap <C-BS> <C-W>

" Move between windows with ctrl + HJKL to switch windows
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

" Open a vertical split with ctrl-f
nnoremap <C-X> :vertical wincmd f<CR>

" Move up/down wrapped lines
nnoremap j gj
nnoremap k gk

" Disable error keys
" map <Left> :echo "no!"<cr>
" map <Right> :echo "no!"<cr>
" map <Up> :echo "no!"<cr>
" map <Down> :echo "no!"<cr>

" Map invisibles to leader-l
nmap <leader>l :set list!<CR>

" Use textmate symbols for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" set netrw to tree mode
let g:netrw_liststyle=3
" set netrw directory tree to 10 pct
let g:netrw_winsize=20
" set netrw to open to the right of browser window
let g:netrw_browse_split=4
let g:netrw_altv=1

" Fix delete key
set backspace=indent,eol,start

" Highlight rows longer than 100 characters
nnoremap <Leader>H :call<SID>LongLineHLToggle()<cr>
hi OverLength ctermbg=none cterm=none
match OverLength /\%>100v/
fun! s:LongLineHLToggle()
 if !exists('w:longlinehl')
  let w:longlinehl = matchadd('ErrorMsg', '.\%>100v', 0)
  echo "Long lines highlighted"
 else
  call matchdelete(w:longlinehl)
  unl w:longlinehl
  echo "Long lines unhighlighted"
 endif
endfunction

" Set tabstop, tabstop, softtabstop and shiftwidth to the same value (stolen from vimcast #2)
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

" ansible
let g:ansible_unindent_after_newline = 1
let g:ansible_attribute_highlight = "ob"
let g:ansible_name_highlight = 'd'
let g:ansible_extra_keywords_highlight = 1

" vim-workspace
nnoremap <leader>s :ToggleWorkspace<CR>
let g:workspace_session_directory = $HOME . '/.vim/sessions/'
let g:workspace_autosave_always = 1
let g:workspace_session_disable_on_args = 1

" vim-gitgutter
set termguicolors
highlight GitGutterAdd    guifg=#009900 guibg=#242424
highlight GitGutterChange guifg=#bbbb00 guibg=#242424
highlight GitGutterDelete guifg=#ff2222 guibg=#242424

" fix vim colors in tmux
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" vim-table-mode: markdown-compatible tables
let g:table_mode_corner='|'

" vimwiki
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'},
      \ {'path': '~/vimwiki-bpf', 'syntax': 'markdown', 'ext': '.md'} ]

" Settings for crontab
autocmd filetype crontab setlocal nobackup nowritebackup

" Use old regex engine, new one is slow on large ruby files
set re=1

" Settings for go:
" Open quickfix windows across bottom of all existing windows
au FileType qf wincmd J

" terminus
au VimEnter * set mouse-=a " disable visual mode on click, has to be run after everything has loaded
