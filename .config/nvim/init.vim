set nocompatible
filetype off

call plug#begin('~/.config/nvim/plugged')
  Plug 'Valloric/YouCompleteMe'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'mileszs/ack.vim'
  Plug 'preservim/nerdcommenter'
  Plug 'wting/rust.vim'
  Plug 'pangloss/vim-javascript'
  Plug 'kchmck/vim-coffee-script'
  Plug 'wookiehangover/jshint.vim'
  Plug 'digitaltoad/vim-jade'
  Plug 'cespare/vim-toml'
  Plug 'fatih/vim-go'
  Plug 'vim-ruby/vim-ruby'
  Plug 'rking/ag.vim'
  Plug 'tpope/vim-dispatch'
  Plug 'bling/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'suan/vim-instant-markdown'
  Plug 'eiginn/netrw'
  Plug 'kana/vim-textobj-user'
  Plug 'jceb/vim-textobj-uri'
  Plug 'mattn/vim-sqlfmt'
  Plug 'tyru/open-browser.vim'
  Plug 'tpope/vim-surround'
call plug#end()

filetype plugin indent on

set number

set colorcolumn=81
autocmd BufWinEnter * match Error /\%>80v.\+\|\s\+$\|^\s*\n\+\%$/

set dir=~/.vim/swap//,/var/tmp//,/tmp//,.

set hlsearch

set expandtab

syntax on

cmap w!! w !sudo tee > /dev/null %

inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
  call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
nnoremap <silent> <leader>t :Files<CR>

let g:airline#extensions#tabline#enabled=1
let g:airline_theme='papercolor'
set noshowmode
set laststatus=2

let g:ackprg = 'ag --vimgrep'

let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

set clipboard=unnamed

let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

command! Sh new | setlocal bt=nofile bh=wipe nobl noswapfile nu
command! Sv vnew | setlocal bt=nofile bh=wipe nobl noswapfile nu
