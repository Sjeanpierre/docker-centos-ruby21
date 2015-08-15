#!/bin/bash -ex
NOTIFICATION_URL="http://requestb.in/17d6ywk1"

cd /tmp
mkdir release
cd release
#download tarball from github using username and application token, extract to current directory
curl -Lk --user "$GH_USER:$GH_TOKEN" $TAR_URL | tar -xz
#set app_git_name to only file in current directory
APP_GIT_NAME=`echo $(ls)`
#extracted tarballs are in the form of repoOwner-repoName-shortSha, repo name is just the middle
REPO_NAME=`echo $APP_GIT_NAME | cut -d'-' --complement -s -f1 | rev | cut -d'-' --complement -s -f1 | rev`
#create build location and move application
mkdir -p /var/www/
cp -r $APP_GIT_NAME /var/www/$REPO_NAME
cd /var/www/$REPO_NAME
#report status to service
curl -X POST -d "host=$(echo $HOSTNAME)" -d "app=$APP_GIT_NAME" -d "phase=prebuild" -d "contents=$(ls)" $NOTIFICATION_URL

#build phase
#remove hard coded ruby version
sed -i '/^ruby/d' ./Gemfile
#bundle install with vendoring
bundle install --deployment --jobs 2 --retry 2
cp config/database.yml.tmpl config/database.yml
bundle exec rake assets:precompile
curl -X POST -d "host=$(echo $HOSTNAME)" -d "app=$APP_GIT_NAME" -d "phase=prepackage" $NOTIFICATION_URL

#package
VERSION=`echo $TAR_URL | rev | cut -d'/' -f1 | rev`
cd ..
fpm -s dir -t rpm --prefix /var/www --name $REPO_NAME --version $VERSION $REPO_NAME
curl -X POST -d "host=$(echo $HOSTNAME)" -d "app=$APP_GIT_NAME" -d "phase=postpackage" -d "contents=$(ls *.rpm)" $NOTIFICATION_URL


