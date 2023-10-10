cite about-plugin
about-plugin 'setup deno'

_command_exists deno || return

if [[ -d "$HOME/.deno" ]]; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi
