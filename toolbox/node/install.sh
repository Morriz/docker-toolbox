#!/usr/bin/env bash

. /toolbox/functions.sh

echo "Copying sources and cache"
cp -r /sources/* .
cp -r /sources/.babelrc .
cp -r /cache node_modules

echo "Doing npm install"
# install artefacts in container
NODE_ENV=development checkRun npm install

echo "Doing npm test"
# run tests and exit when failed
checkRun npm test

echo "Doing npm run build"
# good, build the production artefacts
export NODE_ENV=production
checkRun npm run build

echo "Saving the cache"
# keep the cache
checkRun  yes | cp -r node_modules/.* node_modules/* /cache/

echo "Pruning for production"
# and prune the node_modules folder to get a production version
checkRun npm prune --production

echo "Moving artifacts back"
# move the artifacts back
cp -r build node_modules /sources/
