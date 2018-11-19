#!/bin/bash

# cookie="60gpD=xxx; PHPSESSID=xxx"

[[ -z $cookie ]] && exit 1

urlencode() {
	python3 -c 'import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]));' "$1"
}

jq -r '.[]|.' < postalcodes.json | \
    grep -F ^ | \
    sed -r -e 's/\{([0-9])\}/{\1,\1}/g' -e 's/\^|\$/\//g' -e 's/\\([()])/\1/g' | \
    sort -u | \
    while read -r f; do
	g=$(urlencode "$f");
	echo "$f";
	curl -s 'https://www.dcode.fr/api/' \
	     -H 'User-Agent: Mozilla/5.0' \
	     -H 'Accept: application/json, text/javascript, */*;' \
	     -H 'Referer: https://www.dcode.fr/regular-expression-analyser' \
	     -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
	     -H 'X-Requested-With: XMLHttpRequest' \
	     -H 'Cookie: $cookie' \
	     -H 'TE: Trailers' \
	     --data "tool=regular-expression-analyser&regexp=$g&max_length=true" | \
	    jq -r .results;
	sleep 1;
    done
