#!/usr/bin/env bash
. toolbox/node/functions.sh

source=$1
if [[ -d "$source" ]]; then
  echo "The folder you supplied does not exist"
  exit 1
fi

echo "Removing old build folder and creating fresh one from source"
mkdir .tmp > /dev/null
rm -rf .tmp/docker > /dev/null
rsync -av $source/ .tmp/docker --exclude=node_modules --exclude=build

# docker path to run command in container
do="docker run --rm -t -v $PWD/toolbox/node:/toolbox -v $PWD/.cache/node:/cache -v $PWD/.tmp/docker:/sources -w /app node:6"

echo "Running install scripts and tests"
$do sh /toolbox/install.sh

# clean up
rm -rf .tmp/docker/src .tmp/docker/test

echo "Building the container"
cp toolbox/node/Dockerfile .tmp/docker/Dockerfile
docker build -t $1 .tmp/docker

