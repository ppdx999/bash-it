cite about-plugin
about-plugin 'setup neovim'

NVIM_DIR="${BASH_IT}/vendor/github.com/ppdx999/nvim"

mkdir -p ~/.config/nvim
cp -r "${NVIM_DIR}" ~/.config

alias nv='nvim'
alias apply-nvim-conf='cp -r ${NVIM_DIR} ~/.config/'
alias edit-nvim-conf='${EDITOR:-nvim} ${NVIM_DIR}/init.vim'
