#!/bin/bash

# Make sure you've run "npm install" to install the dev dependencies before running this script!

node_modules/coffee-script/bin/coffee -c src/*.coffee;
rm lib/*.js;
mv src/*.js ./lib/;
node_modules/browserify/bin/cmd.js lib/index.js > map-reporting.js;
node_modules/uglify-js/bin/uglifyjs map-reporting.js -o map-reporting.min.js
