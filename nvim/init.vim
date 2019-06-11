call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'terryma/vim-multiple-cursors'
Plug 'w0rp/ale'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
call plug#end()

let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='hybrid'

set nohlsearch
set nu
set autoindent
set scrolloff=2
set wildmode=longest,list
set ts=4
set sts=4
set sw=1
set autowrite
set autoread
set cindent
set bs=eol,start,indent
set history=256
set paste
set shiftwidth=4
set showmatch
set smartcase
set smarttab
set smartindent
set softtabstop=4
set tabstop=4
set ruler
set incsearch
set laststatus=2
set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\
set expandtab
set cursorline
set cursorcolumn
set fileencoding=utf-8

syntax on
set background=dark
colorscheme hybrid
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif

if empty($TMUX) "TMUX supports 24 bit color space
    if has("nvim")
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1

        if has("termguicolors")
            set termguicolors
        endif
    else
        if &term =~ "xterm"
            let &t_Co = 256
            let &t_ti = "\<Esc>7\<Esc>[r\<Esc>[?47h"
            let &t_te = "\<Esc>[?47l\<Esc>8"
            if has("terminfo")
                let &t_Sf = "\<Esc>[3%p1%dm"
                let &t_Sb = "\<Esc>[4%p1%dm"
            else
                let &t_Sf = "\<Esc>[3%dm"
                let &t_Sb = "\<Esc>[4%dm"
            endif
        endif
    endif
endif
