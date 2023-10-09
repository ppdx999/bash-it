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
nnoremap <leader>j :<C-u>Explore<CR>
nnoremap <C-j> ]b
nnoremap <C-k> [b
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [c :cprevious<CR>
nnoremap ]c :cnext<CR>
nnoremap tt :tabnew<CR>
nnoremap [t :tabprevious<CR>
nnoremap ]t :tabnext<CR>

tnoremap <Esc> <C-\><C-n>

" Plugins
" To install vim plug, run the following command.
" ```
" $ sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" ```

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

" MISC
Plug 'github/copilot.vim'

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

autocmd FileType ddu-ff call s:ddu_ff_keybinds()
function! s:ddu_ff_keybinds() abort
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> i
        \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> q
        \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_ff_filter_keybinds()
function! s:ddu_ff_filter_keybinds() abort
  inoremap <buffer><silent> <CR>
      \ <Esc><Cmd>call ddu#ui#ff#do_action('closeFilterWindow')<CR>
endfunction

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
