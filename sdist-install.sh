#!/bin/bash

pushd /opt/source/ironic
python setup.py sdist
pip install dist/ironic-*
popd

pushd /opt/source/keystone
python setup.py sdist
pip install dist/keystone-*
popd

ironic-dbsync create_schema
keystone-manage db_sync
