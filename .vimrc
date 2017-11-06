set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'wincent/command-t'
Plugin 'mileszs/ack.vim'
Plugin 'The-NERD-Commenter'
Plugin 'wting/rust.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'wookiehangover/jshint.vim'
Plugin 'digitaltoad/vim-jade'
Plugin 'cespare/vim-toml'
Plugin 'fatih/vim-go'
Plugin 'vim-ruby/vim-ruby'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-dispatch'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'suan/vim-instant-markdown'

call vundle#end()
filetype plugin indent on

set number

set colorcolumn=81
autocmd BufWinEnter * match Error /\%>80v.\+\|\s\+$\|^\s*\n\+\%$/

set dir=~/.vim/swap//,/var/tmp//,/tmp//,.

set hlsearch

set expandtab

syntax on

cmap w!! w !sudo tee > /dev/null %

let g:CommandTFileScanner='watchman'

let g:airline#extensions#tabline#enabled=1
let g:airline_theme='papercolor'
set noshowmode
set laststatus=2

let g:ackprg = 'ag --vimgrep'

set clipboard=unnamed
