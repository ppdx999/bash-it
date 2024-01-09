cite about-plugin
about-plugin 'Google Cloud SDK'

# WARNINGS:
# 	This plugin assumes that you have installed the Google Cloud SDK
# 	according to the instructions at https://cloud.google.com/sdk/downloads
# 	and that you have installed it to $HOME/google-cloud-sdk

# The next line updates PATH for the Google Cloud SDK.
if [ -f $HOME/google-cloud-sdk/path.bash.inc ]; then
	. "$HOME/google-cloud-sdk/path.bash.inc"
fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/fujis/google-cloud-sdk/completion.bash.inc' ]; then
	. "$HOME/google-cloud-sdk/completion.bash.inc"
fi
