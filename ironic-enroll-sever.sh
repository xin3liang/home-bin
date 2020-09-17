#!/bin/bash -xe

# An input file should contain bellow format lines.
# <Name> <MAC address> <BMC IP address> <BMC username> <BMC password>
# Where Name is the server production name, e.g.: D05/THX2
# MAC address is the provision interface's MAC.
# 


D05_CPUS=64
THX2_CPUS=128
RAM_MB=32768 #default RAM 32G
DISK_GB=10 # default root disk 10G
RESOURCE_CLASS=baremetal

function get_cpus 
{
    if [[ ${1,,} = "d05" ]]; then
        echo $D05_CPUS
    elif [[ ${1,,} = "thx2" ]]; then
        echo $THX2_CPUS
    else
        echo 0
    fi
}

server_info_file=$1
server_count=1

while read server_info; do
    server_name=$(echo $server_info|awk '{print $1}')
    mac_addr=$(echo $server_info|awk '{print $2}')
    bmc_ip=$(echo $server_info|awk '{print $3}')
    bmc_user=$(echo $server_info|awk '{print $4}')
    bmc_passwd=$(echo $server_info|awk '{print $5}')
    node_name=${server_name,,}-${server_count}
    connector_iqn="iqn.2017-05.org.openstack:node-$node_name"
    cpus=$(get_cpus $server_name)

    # if flavor not existed, 
    # then create it
    flavor_name=bm-${server_name,,}
    flavor=$(openstack flavor list|grep -i $flavor_name) || true
    if [[ -z $flavor ]];then
        resource_class=CUSTOM_${RESOURCE_CLASS^^}_${server_name^^}
        openstack flavor create --ram $RAM_MB --vcpus $cpus \
            --disk $DISK_GB  $flavor_name
        openstack flavor set $flavor_name \
            --property resources:$resource_class=1 \
            --property resources:VCPU=0 \
            --property resources:MEMORY_MB=0 \
            --property resources:DISK_GB=0 \
            --property capabilities:boot_option='netboot'
    fi

    deploy_kernel_id=$(openstack image show bm-deploy-kernel \
                        -f value -c id)
    deploy_initrd_id=$(openstack image show bm-deploy-initrd \
                        -f value -c id)
    resource_class=${RESOURCE_CLASS,,}-${server_name,,}

    # Note: Set capabilities=boot_option:local if it has disk.
    node_id=$(openstack baremetal node create \
        --name $node_name \
        --driver ipmi \
        --driver-info ipmi_username=$bmc_user \
        --driver-info ipmi_password=$bmc_passwd \
        --driver-info ipmi_address=$bmc_ip \
        --driver-info deploy_kernel=$deploy_kernel_id \
        --driver-info deploy_ramdisk=$deploy_initrd_id \
        --resource-class $resource_class \
        --property cpu_arch=aarch64 \
        --property cpus=$cpus \
        --property memory_mb=$RAM_MB \
        --property capabilities='boot_mode:uefi,iscsi_boot:True,boot_option:netboot' \
        --storage-interface cinder \
        --deploy-interface iscsi \
        -f value -c uuid)
    
    openstack baremetal port create $mac_addr --node $node_id
    #--physical-network physnet1

    # create initiator
    openstack baremetal volume connector create \
        --node $node_id --type iqn \
        --connector-id $connector_iqn
    
    openstack baremetal node manage $node_id
    openstack baremetal node provide $node_id

    server_count=$((server_count+1))
done < $server_info_file
