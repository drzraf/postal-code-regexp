short.json:
	jq -cr 'map(select(.Regex != "" and .ISO != "")) | map({(.ISO): .Regex}) | add ' full.json >| short.json
