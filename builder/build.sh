#!/bin/bash -ex

cd /tmp
mkdir release
cd release
curl -Lk --user "$GH_USER:$GH_TOKEN" $TAR_URL | tar -xz
APP_GIT_NAME=`echo $(ls)`
REPO_NAME=`echo $APP_GIT_NAME | cut -d'-' --complement -s -f1 | rev | cut -d'-' --complement -s -f1 | rev`
mkdir -p /var/www/
cp -r $APP_GIT_NAME /var/www/$REPO_NAME
cd /var/www/$REPO_NAME
curl -X POST -d "host=$(echo $HOSTNAME)" -d "fizz=$(ls)" http://requestb.in/17d6ywk1
