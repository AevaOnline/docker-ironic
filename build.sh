#!/bin/bash

VERSION='6.0.0'

set -e -x

git submodule update
git submodule sync

pushd ironic
git remote update
git checkout $VERSION
python setup.py sdist
mv dist/ironic-${VERSION}.tar.gz ../ironic.tar.gz
popd

docker build --rm -q -t ironic:latest -f allinone/Dockerfile .

docker build --rm -q -t ironic:devel -f devel/Dockerfile .
