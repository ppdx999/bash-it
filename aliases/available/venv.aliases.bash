# shellcheck shell=bash
about-alias "python venv abbreviations"

_command_exists virtualenv || return

alias venv-create='python -m venv venv'
alias venv='source venv/bin/activate'
