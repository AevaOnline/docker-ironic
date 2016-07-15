#!/bin/bash

export OS_IDENTITY_API_VERSION=3
export OS_PROJECT_NAME=local
export OS_DOMAIN=default
export OS_USERNAME=admin 
export OS_PASSWORD=admin_pass 
export OS_AUTH_URL=http://127.0.0.1:35357/v3

export OS_BOOTSTRAP_USERNAME=$OS_USERNAME
export OS_BOOTSTRAP_PASSWORD=$OS_PASSWORD
export OS_BOOTSTRAP_PROJECT_NAME=$OS_PROJECT_NAME
export OS_BOOTSTRAP_ADMIN_URL=$OS_AUTH_URL
export OS_BOOTSTRAP_PUBLIC_URL=$OS_AUTH_URL
export OS_BOOTSTRAP_INTERNAL_URL=$OS_AUTH_URL
export OS_BOOTSTRAP_SERVICE_NAME=keystone

keystone-manage bootstrap
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
