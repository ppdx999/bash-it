cite about-plugin
about-plugin 'Plugin to manage pm2 processes'

function pm2-run() {
	# pm2-run <npm_cmd> <user_cmd> <user_cmd_args>
	# USAGE:
	# 	pm2-run "npm run" "node" "index.js"
	# 		# or
	# 	pm2-run "yarn" "node" "index.js"
	# 		# or
	# 	pm2-run "pnpm" "node" "index.js
	npm_cmd=$1
	shift
	user_cmd=$1
	shift
	user_cmd_args=$@

	cwd=$(pwd | xargs basename)

	pm2 start "$npm_cmd" \
		--name "$user_cmd-$cwd" \
		-- "$user_cmd" "$user_cmd_args"
}
