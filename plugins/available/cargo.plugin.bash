cite about-plugin
about-plugin 'Cargo is a tool that allows Rust projects to declare their various dependencies and ensure that you’ll always get a repeatable build.'

if [[ -d "$HOME/.cargo/bin" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi
