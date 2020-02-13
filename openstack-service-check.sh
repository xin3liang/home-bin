#!/bin/bash -xe

services="compute volume"

for svc in ${services}
do
	openstack $svc service list --long
done

openstack network agent list
