" Symlink or copy this to init.vim in:
" macOS, Linux ~/.config/nvim/
" Windows ~/AppData/Local/nvim/

" Core
set number
set relativenumber
set laststatus=2
set nomodeline
set bs=2
set mouse=a
set nowrap
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set smarttab
set autoindent
set copyindent
set backspace=indent,eol,start
set showmatch
set ignorecase
set smartcase
set hlsearch
set incsearch
set scrolloff=5
set sidescrolloff=5
set wildmenu
set wildmode=longest:full,full
set hidden
set undofile
set cursorline
set ruler
set fileencodings=utf-8,cp1251,cp866,koi8-r
set background=dark

" Neovim uses UTF-8 internally. 'encoding' and 'termencoding' are not set here.

" Russian input method for Insert mode
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0

" Russian keyboard layout support in Normal and Visual modes
lua << EOF
local ru = "ёйцукенгшщзхъфывапролджэячсмитьбю"
local en = "`qwertyuiop[]asdfghjkl;'zxcvbnm,."

local RU = "ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ"
local EN = '~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>'

vim.opt.langmap =
    ru .. ";" .. vim.fn.escape(en, [[,;\]]) .. "," ..
    RU .. ";" .. vim.fn.escape(EN, [[,;\]])
EOF

" Status line
set statusline=%<%f\ %h%w%m%r%y%=L:%l/%L\ (%p%%)\ C:%c%V\ B:%o\ F:%{foldlevel('.')}

" Filetype support
filetype plugin indent on
syntax enable

" Leader key
let mapleader="," 

" Save with sudo using :w!!
cmap w!! w !sudo tee % >/dev/null

" Plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'morhetz/gruvbox'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'dense-analysis/ale'
Plug 'mbbill/undotree'
Plug 'junegunn/fzf.vim'
call plug#end()

" Colors
highlight lCursor guifg=NOgruvboxNE guibg=Cyan
set termguicolors
colorscheme gruvbox

" Airline
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#tabline#enabled=1

" ALE
let g:ale_linters_explicit=0
let g:ale_sign_error='✗'
let g:ale_sign_warning='⚠'
let g:ale_echo_msg_format='[%linter%] %s'
let g:ale_fix_on_save=0
let g:ale_lint_on_text_changed='normal'
let g:ale_lint_on_save=1

" File format cycle: F7
function! RotateFileFormat() abort
  let l:formats = ['unix', 'dos', 'mac']
  let b:fformatindex = get(b:, 'fformatindex', 0)
  execute 'setlocal fileformat=' . l:formats[b:fformatindex]
  let b:fformatindex = (b:fformatindex + 1) % len(l:formats)
  echo 'fileformat=' . &l:fileformat
endfunction
nnoremap <F7> :call RotateFileFormat()<CR>

" Re-read current file using the next encoding: F8
let s:file_read_encodings = ['koi8-r', 'cp1251', 'cp866', 'utf-8', 'ucs-2le']
function! RotateReadEncoding() abort
  let b:readencindex = get(b:, 'readencindex', 0)
  let l:encoding = s:file_read_encodings[b:readencindex]
  let b:readencindex = (b:readencindex + 1) % len(s:file_read_encodings)
  execute 'edit ++enc=' . l:encoding
  echo 're-read using ' . l:encoding
endfunction
nnoremap <F8> :call RotateReadEncoding()<CR>

" Set the encoding used when writing: Ctrl-F8
function! RotateWriteEncoding() abort
  let l:encodings = ['koi8-r', 'cp1251', 'cp866', 'utf-8', 'ucs-2le']
  let b:writeencindex = get(b:, 'writeencindex', 0)
  let &l:fileencoding = l:encodings[b:writeencindex]
  let b:writeencindex = (b:writeencindex + 1) % len(l:encodings)
  echo 'fileencoding=' . &l:fileencoding
endfunction
nnoremap <C-F8> :call RotateWriteEncoding()<CR>

" Note: Neovim's internal encoding is always UTF-8. The old Shift-F8
" mapping changed Vim's global 'encoding' option, which Neovim does not have.

" Tab completion: insert a literal Tab when not after a keyword; otherwise
" cycle through completion candidates.
function! InsertTabWrapper(direction) abort
  let l:col = col('.') - 1
  if l:col == 0 || getline('.')[l:col - 1] !~# '\k'
    return "\<Tab>"
  elseif a:direction ==# 'backward'
    return "\<C-p>"
  else
    return "\<C-n>"
  endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper('forward')<CR>
inoremap <S-Tab> <C-r>=InsertTabWrapper('backward')<CR>

" Homebrew fzf integration (Apple Silicon path)
if isdirectory('/opt/homebrew/opt/fzf')
    set rtp+=/opt/homebrew/opt/fzf
endif

autocmd VimEnter *
    \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) |
    \   PlugInstall --sync |
    \ endif