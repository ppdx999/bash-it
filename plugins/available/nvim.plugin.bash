cite about-plugin
about-plugin 'setup neovim'

NVIM_DIR="${BASH_IT}/vendor/github.com/ppdx999/nvim"

mkdir -p ~/.config/nvim

alias nv='nvim'
alias apply-nvim-conf='cp ${NVIM_DIR}/init.lua ~/.config/nvim/init.lua'
alias edit-nvim-conf='${EDITOR:-nvim} ${NVIM_DIR}/init.lua'
