
cite about-plugin
about-plugin 'setup pnpm'

_command_exists pnpm || return


if [[ -d "$HOME/.local/share/pnpm" ]]; then
  export PNPM_HOME="$HOME/.local/share/pnpm"
  export PATH="$PNPM_HOME:$PATH"
fi
