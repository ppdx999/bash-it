cite about-plugin
about-plugin 'setup deno'

_command_exists deno || return

if [[ -d "$HOME/.deno" ]]; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

function deno-setup-nvim {
	if [ -f .vim/coc-settings.json ]; then
		cp .vim/coc-settings.json .vim/coc-settings.json.bak
	fi

	# Setup coc-settings.json
	# Because coc-settings can't automatically detect deno instead of nodejs,
	# we need to disable tsserver and eslint, and enable deno manually.
	mkdir -p .vim
	cat << EOF > .vim/coc-settings.json
	{
		"deno.enable": true,
		"deno.lint": true,
		"deno.unstable": true,
		"prettier.disableLanguages": ["typescript"],
		"typescript.format.enabled": false,
		"eslint.enable": false,
		"tsserver.enable": false
	}
EOF
}
