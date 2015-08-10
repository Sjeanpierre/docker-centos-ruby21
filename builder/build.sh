#!/bin/bash -ex

cd /tmp
mkdir release
cd release
curl -Lk --user "$GH_USER:$GH_TOKEN" $TAR_URL | tar -xz
cd *
ls
