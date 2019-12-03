all: short.json fmt.json

short.json:
	jq -cr 'map(select(.Regex != "" and .ISO != "")) | map({(.ISO): .Regex}) | add' full.json us.json uk.json | jq -csS add >| short.json
fmt.json:
	jq -cr 'map(select(.Regex != "" and .ISO != "")) | map({(.ISO): [.Format, .Regex]}) | add' full.json us.json uk.json | jq -csS 'add' >| fmt.json

ar-provinces.json:
	# Get provinces/city from https://gist.github.com/lucsh/cb55fbcb4ff291c0368b7f43730cdd94/
	# and any textql-like tool.
	 q -HOd ';' "SELECT DISTINCT l.cp, GROUP_CONCAT(DISTINCT p.letter) as letters FROM ./localidades.csv AS l LEFT JOIN ./provincias.csv AS p ON l.idProvincia = p.id GROUP BY l.cp HAVING count(DISTINCT p.letter) > 1" > dup.csv
	q -d ';' -W all -D ':' -H "SELECT DISTINCT l.cp, p.letter FROM ./localidades.csv AS l LEFT JOIN ./provincias.csv AS p ON l.idProvincia = p.id WHERE l.cp NOT IN (SELECT cp FROM ./dup.csv) UNION SELECT cp, letters FROM dup.csv"|tr "\n" ,
