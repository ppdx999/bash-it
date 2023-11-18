cite about-plugin
about-plugin 'Flyctl is a command line interface for Fly.io'

if [[ -d "$HOME/.fly" ]]; then
  export FLYCTL_INSTALL="/home/fujis/.fly"
  export PATH="$FLYCTL_INSTALL/bin:$PATH"
fi
