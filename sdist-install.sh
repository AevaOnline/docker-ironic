#!/bin/bash

set -e -x

pushd /opt/source/ironic
python setup.py develop
#python setup.py sdist
#pip install dist/ironic-*
popd

pushd /opt/source/keystone
python setup.py sdist
pip install dist/keystone-*
popd

rm -f /etc/ironic/ironic.sqlite
ironic-dbsync create_schema
chown ironic:ironic /etc/ironic/ironic.sqlite

rm -f /etc/keystone/keystone.sqlite
keystone-manage db_sync
chown keystone:keystone /etc/keystone/keystone.sqlite
