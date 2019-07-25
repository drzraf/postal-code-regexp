all: short.json fmt.json

short.json:
	jq -cr 'map(select(.Regex != "" and .ISO != "")) | map({(.ISO): .Regex}) | add' full.json us.json uk.json | jq -csS add >| short.json
fmt.json:
	jq -cr 'map(select(.Regex != "" and .ISO != "")) | map({(.ISO): [.Format, .Regex]}) | add' full.json us.json uk.json | jq -csS 'add' >| fmt.json
