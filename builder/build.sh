#!/bin/bash -ex

cd /tmp
mkdir release
cd release
curl -Lk --user "$GH_USER:$GH_TOKEN" $TAR_URL | tar -xz
cd *
ls
curl -X POST -d "host=$(echo $HOSTNAME)" -d "fizz=$(ls)" http://requestb.in/1n6jlsc1
