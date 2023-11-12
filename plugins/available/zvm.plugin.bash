cite about-plugin
about-plugin 'zig version manager'


if [[ -d "$HOME/.zvm" ]]; then
  export ZVM_INSTALL="$HOME/.zvm/self"
  export PATH="$PATH:$HOME/.zvm/bin"
  export PATH="$PATH:$ZVM_INSTALL/"
fi


if ! _command_exists zvm; then
  function zvm() {
    echo "zvm is not installed."
    echo ""
    echo "See here to install nzm"
    echo "https://github.com/tristanisham/zvm/tree/master"
  }
fi
