#!/usr/bin/env bash

DIR=$(dirname $0)
pushd $DIR > /dev/null

if [[ ! -d node_modules ]]; then
	echo 'Installing compiler tools...'
	sleep 1
	npm install
fi

echo 'Compiling map-reporting...'

node_modules/coffee-script/bin/coffee -c src/*.coffee
rm lib/*.js
mv src/*.js lib/
echo -n '// map-reporting ' > map-reporting.js
node_modules/coffee-script/bin/coffee -e 'console.log JSON.parse(require("fs").readFileSync("./package.json").toString "utf8").version' >> map-reporting.js
node_modules/browserify/bin/cmd.js lib/index.js >> map-reporting.js
node_modules/uglify-js/bin/uglifyjs map-reporting.js -o map-reporting.min.js

popd > /dev/null
echo 'Done!'
