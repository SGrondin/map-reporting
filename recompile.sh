#!/bin/bash

DIR=`dirname $0`

if [ ! -d $DIR/node_modules ]; then
	echo 'Installing compiler tools...'
	sleep 1
	(cd $DIR; npm install)
fi

echo 'Compiling map-reporting...'

$DIR/node_modules/coffee-script/bin/coffee -c $DIR/src/*.coffee
rm $DIR/lib/*.js
mv $DIR/src/*.js $DIR/lib/
echo -n '// map-reporting ' > $DIR/map-reporting.js
$DIR/node_modules/coffee-script/bin/coffee -e 'console.log JSON.parse(require("fs").readFileSync("'$DIR'/package.json").toString "utf8").version' >> $DIR/map-reporting.js
$DIR/node_modules/browserify/bin/cmd.js $DIR/lib/index.js >> $DIR/map-reporting.js
$DIR/node_modules/uglify-js/bin/uglifyjs $DIR/map-reporting.js -o $DIR/map-reporting.min.js

echo 'Done!'
