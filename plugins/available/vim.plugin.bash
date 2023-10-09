cite about-plugin
about-plugin 'Vim plugin for bash'

VIM_DIR="${BASH_IT}/vendor/github.com/ppdx999/vim"
mkdir -p "$HOME/.vim/autoload"

alias v='vim'
alias vi='vim'
alias apply-vim-conf='cp ${VIM_DIR}/.vimrc ${HOME}/.vimrc && cp ${VIM_DIR}/plug.vim ${HOME}/.vim/autoload/plug.vim'
alias edit-vim-conf='vim ${VIM_DIR}/.vimrc'
