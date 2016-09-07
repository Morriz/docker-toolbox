# Microservices container tools

This suite contains tools to play with dockerizing your project. Please make sure you have docker running natively for this to work!

## Node.js projects

Just run:

    ./build-node.sh $folder $imageName
    
from the root of this project, with `$folder` pointing to a Node.js project on disk.

It should be able to start your node app with `node .`. This is to accomodate the lean docker containers it creates (without npm).
So be sure to set the `main` script in your `package.json`!
