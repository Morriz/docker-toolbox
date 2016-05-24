#@IgnoreInspection BashAddShebang
. /toolbox/functions.sh

echo "Copying sources and cache"
cp -r /sources/* .
cp -r /sources/.babelrc .
cp -r /cache node_modules

echo "Doing npm install"
NODE_ENV=development checkRun npm install

echo "Doing npm test"
checkRun npm test

echo "Doing npm run build"
export NODE_ENV=production
checkRun npm run build

echo "Saving the cache"
checkRun  yes | cp -r node_modules/.* node_modules/* /cache/

echo "Pruning for production"
checkRun npm prune --production

echo "Moving artifacts back"
cp -r build node_modules /sources/
