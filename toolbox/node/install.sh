#@IgnoreInspection BashAddShebang
. /toolbox/functions.sh

echo "Copying sources"
cp -r /sources/* .
cp -r /sources/.babelrc .
# some perm fixing on our npm cache for Docker for Mac:
chown -R root /root/.npm
chmod -R 777 /root/.npm

echo "Doing npm install"
NODE_ENV=development checkRun npm install

echo "Doing npm test"
checkRun npm test

echo "Doing npm run build"
export NODE_ENV=production
checkRun npm run build

echo "Pruning for production"
checkRun npm prune --production

echo "Moving artifacts back"
cp -r build node_modules /sources/
