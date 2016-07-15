#!/bin/bash

set -e -x

export OS_IDENTITY_API_VERSION=3
export OS_PROJECT_NAME=local
export OS_DOMAIN=default
export OS_USERNAME=admin 
export OS_PASSWORD=admin_pass 
export OS_AUTH_URL=http://127.0.0.1:35357/v3

openstack service create baremetal --name ironic --desc "bare metal service"
openstack endpoint create -f value baremetal admin http://127.0.0.1:6385/
openstack endpoint create -f value baremetal internal http://127.0.0.1:6385/
# this is to fix a bug in openstackclient
openstack endpoint create -f value baremetal public http://127.0.0.1:6385/

openstack user create --domain default --project local --project-domain default --password password ironic
openstack role add --user-domain default --project-domain default --project local --user ironic admin

openstack role create baremetal_admin
openstack role create baremetal_observer

openstack user create --domain default --project local --project-domain default --password password player_one
openstack role add --user-domain default --project-domain default --project local --user player_one baremetal_admin

openstack user create --domain default --project local --project-domain default --password password player_two
openstack role add --user-domain default --project-domain default --project local --user player_two baremetal_observer

if [[ ${0%$(basename $0)} == '/etc/init.d/' ]]; then
    rm $0
fi
