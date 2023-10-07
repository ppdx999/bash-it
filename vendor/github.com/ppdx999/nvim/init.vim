" Encoding
set encoding=utf-8

" Visual
set ambiwidth=double
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent

set visualbell
set number
set showmatch
set matchtime=1
set nowrap

" Search
set incsearch
set ignorecase
set smartcase
set hlsearch
nnoremap <Esc><Esc> :nohl<CR>

" Manipulation
let mapleader = ";"
set clipboard+=unnamedplus
set ttimeout
set ttimeoutlen=50

" Keymaps
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>v :<C-u>vs<CR>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>
nnoremap tt :tabnew<CR>
nnoremap ]t :tabnext<CR>
nnoremap [t :tabprevious<CR>

" Plugins
" To install run
" ```
" $ sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" ```

call plug#begin()

" Denops
Plug 'vim-denops/denops.vim'
Plug 'vim-denops/denops-helloworld.vim'

" DDU
Plug 'Shougo/ddu.vim'
Plug 'Shougo/ddu-commands.vim'
Plug 'Shougo/ddu-ui-ff'
Plug 'Shougo/ddu-ui-filer'
Plug 'Shougo/ddu-kind-file'
Plug 'Shougo/ddu-source-file'
Plug 'Shougo/ddu-source-file_rec'
Plug 'shun/ddu-source-buffer'
Plug 'Shougo/ddu-filter-matcher_substring'
Plug 'Shougo/ddu-column-filename'

" MISC
Plug 'github/copilot.vim'

call plug#end()


call ddu#custom#patch_local('ff', {
    \   'ui': 'ff',
    \   'sources': [{'name': 'file_rec', 'params': {}}, {'name': 'buffer', 'params': {}}],
    \   'sourceOptions': {
    \     '_': {
    \       'matchers': ['matcher_substring'],
    \     },
    \   },
    \   'kindOptions': {
    \     'file': {
    \       'defaultAction': 'open',
    \     },
    \   }
    \ })

call ddu#custom#patch_local('filer', {
    \   'ui': 'filer',
    \   'sources': [{'name': 'file', 'params': {}}],
    \   'sourceOptions': {
    \     '_': {
    \       'matchers': ['matcher_substring'],
    \       'columns': ['filename'],
    \     },
    \   },
    \   'kindOptions': {
    \     'file': {
    \       'defaultAction': 'open',
    \     },
    \   },
    \ })

"ddu-key-setting
autocmd FileType ddu-ff call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> i
        \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> q
        \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

function! s:ddu_filter_my_settings() abort
  nnoremap <buffer> <CR>
  \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> q
  \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-filer call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> q
        \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

function! s:ddu_filter_my_settings() abort
  nnoremap <buffer> <CR>
  \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> q
  \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

nnoremap <silent> <leader>uf :<C-u>Ddu file_rec -name=ff<CR>
nnoremap <silent> <leader>ub :<C-u>Ddu buffer -name=ff<CR>
nnoremap <silent> <leader>uj :<C-u>Ddu file -name=filer<CR>
