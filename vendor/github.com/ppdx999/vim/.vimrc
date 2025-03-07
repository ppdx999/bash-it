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
set laststatus=2

" Search
set incsearch
set ignorecase
set smartcase
set hlsearch
nnoremap <Esc><Esc> :nohl<CR>

" Manipulation
let mapleader = ";"
set clipboard+=unnamed
set clipboard+=autoselect
set ttimeout
set ttimeoutlen=50
set mouse=a

" Keymaps
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>v :<C-u>vs<CR>
nnoremap <leader>j :<C-u>Explore<CR>
nnoremap <C-j> :bnext<CR>
nnoremap <C-k> :bprevious<CR>
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [c :cprevious<CR>
nnoremap ]c :cnext<CR>
nnoremap tt :tabnew<CR>
nnoremap [t :tabprevious<CR>
nnoremap ]t :tabnext<CR>

" Plugins
call plug#begin()

" Denops
Plug 'vim-denops/denops.vim'
Plug 'vim-denops/denops-helloworld.vim'

" DDU
Plug 'Shougo/ddu.vim'
Plug 'Shougo/ddu-ui-ff'
Plug 'Shougo/ddu-kind-file'
Plug 'Shougo/ddu-filter-matcher_substring'
Plug 'Shougo/ddu-source-file_rec'
Plug 'Shougo/ddu-source-file_external'
Plug 'shun/ddu-source-buffer'
Plug 'lambdalisue/mr.vim'
Plug 'kuuote/ddu-source-mr'
Plug 'Shougo/ddu-source-register'
Plug 'shun/ddu-source-rg'

" DDC
Plug 'Shougo/ddc.vim'
Plug 'Shougo/ddc-ui-native'
Plug 'Shougo/ddc-filter-matcher_head'
Plug 'shun/ddc-source-vim-lsp'

" GIT
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" MISC
Plug 'github/copilot.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'jabirali/vim-tmux-yank'
Plug 'gyim/vim-boxdraw'
Plug 'godlygeek/tabular'

" LSP
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" Filer
Plug 'lambdalisue/fern.vim'

" Colorschema
Plug 'sainnhe/everforest'

" Elixir
Plug 'elixir-editors/vim-elixir'

call plug#end()

" DDU SETTINGS
call ddu#custom#patch_global({
    \   'ui': 'ff',
    \   'sourceOptions': {
    \     '_': {'matchers': ['matcher_substring']},
    \   },
    \   'kindOptions': {
    \     'file': {'defaultAction': 'open'},
    \   }
    \ })

function! s:ddu_ff_keybinds() abort
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> i
        \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> q
        \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

function! s:ddu_ff_filter_keybinds() abort
  inoremap <buffer><silent> <CR>
      \ <Esc><Cmd>call ddu#ui#ff#do_action('closeFilterWindow')<CR>
endfunction

augroup ddu_ff_keymaps
  autocmd!
  autocmd FileType ddu-ff call s:ddu_ff_keybinds()
  autocmd FileType ddu-ff-filter call s:ddu_ff_filter_keybinds()
augroup END

function! s:launch_ddu_file() abort
  " If current dir has .git, use Ddu file_external,
  " otherwise use Ddu file_rec
  let l:git_dir = finddir('.git', '.;')
  if l:git_dir != ''
    call ddu#start(#{
      \  sources: [#{name: 'file_external'}],
      \  sourceParams: #{
      \    file_external: #{
      \      cmd: ['git', 'ls-files'],
      \    },
      \  },
      \})
  else
    call ddu#start(#{sources: [#{name: 'file_rec'}]})
  endif
endfunction

function! s:launch_ddu_buffer() abort
  call ddu#start(#{sources: [#{name: 'buffer'}]})
endfunction

function! s:launch_ddu_mr() abort
  call ddu#start(#{sources: [#{name: 'mr'}]})
endfunction

function! s:launch_ddu_register() abort
  call ddu#start(#{sources: [#{name: 'register'}]})
endfunction

function! s:launch_ddu_rg_live() abort
  call ddu#start(#{
        \   sources: [#{
        \     name: 'rg',
        \     options: #{
        \       matchers: [],
        \       volatile: v:true,
        \     },
        \   }],
        \   uiParams: #{
        \     ff: #{
        \       ignoreEmpty: v:false,
        \       autoResize: v:false,
        \     }
        \   },
        \ })
endfunction

nnoremap <silent> <leader>f :<C-u>call <SID>launch_ddu_file()<CR>
nnoremap <silent> <leader>b :<C-u>call <SID>launch_ddu_buffer()<CR>
nnoremap <silent> <leader>m :<C-u>call <SID>launch_ddu_mr()<CR>
nnoremap <silent> <leader>r :<C-u>call <SID>launch_ddu_register()<CR>
nnoremap <silent> <leader>g :<C-u>call <SID>launch_ddu_rg_live()<CR>

" DDC SETTINGS
call ddc#custom#patch_global('ui', 'native')
call ddc#custom#patch_global('sources', ['vim-lsp'])
call ddc#custom#patch_global('sourceOptions', #{
      \ vim-lsp: #{
      \  matchers: ['matcher_head'],
      \  mark: 'lsp',
      \ }
      \})
call ddc#enable()

" LSP SETTINGS
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> KK <plug>(lsp-document-diagnostics)
    nmap <buffer> KF <plug>(lsp-document-format)
    nmap <buffer> KE <cmd>let g:lsp_diagnostics_highlights_enabled = !g:lsp_diagnostics_highlights_enabled<CR>
    nmap <buffer> gh <plug>(lsp-hover)
    " nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    " nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_diagnostics_highlights_enabled = 0
    let g:lsp_diagnostics_virtual_text_enabled = 0
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" FERN SETTINGS
nnoremap <silent> <leader>j :<C-u>Fern . -reveal=%<CR>
function! s:init_fern() abort
  let g:fern#default_hidden = 1
  nmap <buffer><silent> D <Plug>(fern-action-remove)<CR>
endfunction
augroup fern_init
  autocmd!
  autocmd FileType fern call s:init_fern()
augroup END

" Color Setting
function! s:color_setting() abort
  highlight QuickFixLine ctermbg=22
endfunction

augroup color_setting
  autocmd!
  autocmd ColorScheme * call s:color_setting()
augroup END
colorscheme default

" QuickFix
function! s:quickfix_setting() abort
  nnoremap <buffer> p <CR>zz<C-w>p
endfunction

augroup quickfix_setting
  autocmd!
  autocmd FileType qf call s:quickfix_setting()
augroup END

"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
" Everforest Settings
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

" Important!!
if has('termguicolors')
  set termguicolors
endif

" For dark version.
set background=dark

" Set contrast.
" This configuration option should be placed before `colorscheme everforest`.
" Available values: 'hard', 'medium'(default), 'soft'
let g:everforest_background = 'hard'

" For better performance
let g:everforest_better_performance = 1

colorscheme everforest
