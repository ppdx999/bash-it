about-completion "Bash completion for zig"

mkdir -p "$HOME/.local/share/bash-completions"

if [ ! -f "$HOME/.local/share/bash-completions/zig" ]; then
    echo "Downloading bash completion for zig"
    curl -L \
      "https://raw.githubusercontent.com/ziglang/shell-completions/master/_zig.bash" \
      -o "$HOME/.local/share/bash-completions/zig"
fi

source "$HOME/.local/share/bash-completions/zig"
