#!/usr/bin/env bash
. toolbox/node/functions.sh

source=$1
imageName=$2

if [[ ! -d "$source" ]]; then
  echo "The folder you supplied does not exist"
  exit 1
fi

if [ "$imageName" == "" ]; then
  echo "No image name supplied after folder"
  exit 1
fi

echo "Dockerizing node.js project in folder $source and committing under image name $imageName"

excludeFromGitignore=''
if [[ -f "$source/.gitignore" ]]; then
  excludeFromGitignore="--exclude-from=$source/.gitignore"
fi

echo "Removing old build folder and creating fresh one from source"
mkdir .tmp > /dev/null
rm -rf .tmp/docker > /dev/null
cmd="rsync -av $source/ .tmp/docker --exclude=.git --exclude=node_modules $excludeFromGitignore"
echo $cmd
$cmd

# docker path to run command in container
do="docker run --rm -t -v $PWD/toolbox/node:/toolbox -v $PWD/.cache/node:/root/.npm -v $PWD/.tmp/docker:/sources -w /app node:6"
echo $do

echo "Running install scripts and tests"
checkRun $do sh /toolbox/install.sh

# clean up
rm -rf .tmp/docker/src .tmp/docker/test

echo "Building the container"
cp toolbox/node/Dockerfile .tmp/docker/Dockerfile
docker build -t $imageName .tmp/docker
