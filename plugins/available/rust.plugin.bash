cite about-plugin
about-plugin 'setup rust'

[[ -d "$HOME/.cargo/bin" ]] && export PATH="$PATH:$HOME/.cargo/bin"
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
