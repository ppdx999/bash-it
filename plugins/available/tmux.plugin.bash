# setup tmux

cite about-plugin
about-plugin 'setup tmux'

TMUX_CONF_PATH="${BASH_IT}/vendor/github.com/ppdx999/tmux/.tmux.conf"
cp "${TMUX_CONF_PATH}" ~/.tmux.conf

alias tmux="TERM=xterm-256color tmux"
alias edit-tmux-conf='${EDITOR:-vim} ${TMUX_CONF_PATH}'
