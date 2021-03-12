#!/bin/bash -e

# An input file should contains bellow format lines.
# <Model> <Name> <MAC address> <BMC IP address> <BMC username> <BMC password> [Target address] <Boot option> [<Root disk hint> <Root disk hint value>]
#
# Where
# <Model> is the server production name, e.g.: D05/THX1/THX2
#
# <Name> can be 'auto' or a specific name e.g. "racke-d05-01"
#
# <MAC address> is the provision interface's MAC.
#
# [Target address] for multi-node machine, e.g. FX700
#
# <Boot option> is 'local' for local disk boot or 'netboot' for iscsi volume boot
#
# [<Root disk hint> <Root disk hint value>] For specify a local disk to install OS
# see what hints support here: https://docs.openstack.org/ironic/latest/install/advanced.html#specifying-the-disk-for-deployment-root-device-hints
# Use lsblk to get related hint, e.g. lsblk -o SERIAL,NAME,SIZE, lsblk -h for more info.
#
# Example lines:
# D05 auto a0:a3:3b:c1:41:b9 172.27.64.50 root Huawei12#$ netboot
# THX1 rack3-thx1-02 a0:a3:3b:c1:41:b9 172.27.64.51 root Huawei12#$ local serial 160811E5163F
# FX700 rack4-fx700-node2 2C:D4:44:CE:90:A2 172.27.64.160 hpcmainte HPCMAINTE 0x34 netboot


RAM_MB=32768 #default RAM 32G
DISK_GB=10 # default root disk 10G
RESOURCE_CLASS=baremetal

function get_cpus 
{
    model=${1,,}
    case $model in
        thx1 | fx700)
	    cpus=48
	    ;;
        d05)
	    cpus=64
	    ;;
        thx2)
	    cpus=128
	    ;;
	*)
	    cpus=0
	    ;;
    esac

    echo $cpus
}

echo "Check BMC connectivity..."
server_info_file=$1
server_count=1
fail_count=0
fail_ips=""
while read server_info; do
    model=$(echo $server_info|awk '{print $1}')
    bmc_ip=$(echo $server_info|awk '{print $4}')
    bmc_user=$(echo $server_info|awk '{print $5}')
    bmc_passwd=$(echo $server_info|awk '{print $6}')
    bmc_extra_opts=""
    if [[ "${model,,}" = "fx700" ]]; then
        target_addr=$(echo $server_info|awk '{print $7}')
        bmc_extra_opts+=" -L USER -t $target_addr"
    fi

    ret=0
    ipmitool -I lanplus -H $bmc_ip  -U $bmc_user -P $bmc_passwd $bmc_extra_opts  power status || ret=1
    if [[ "$ret" = 0 ]]; then
	echo "$bmc_ip ok"
    else
        echo "$bmc_ip fail"
        fail_count=$((fail_count+1))
        fail_ips+=" $bmc_ip"
    fi
done < $server_info_file

if [[ $fail_count -gt 0 ]]; then
	echo "Fail count: $fail_count."
        echo "Please check fail BMC IP:"
	for ip in $fail_ips; do
	    echo $ip
        done
	echo "Check BMC connectivity finish."
	exit 1
fi
echo "Check BMC connectivity finish."

echo "Enroll server..."
while read server_info; do
    model=$(echo $server_info|awk '{print $1}')
    name=$(echo $server_info|awk '{print $2}')
    mac_addr=$(echo $server_info|awk '{print $3}')
    bmc_ip=$(echo $server_info|awk '{print $4}')
    bmc_user=$(echo $server_info|awk '{print $5}')
    bmc_passwd=$(echo $server_info|awk '{print $6}')

    i=0
    node_opts=""
    if [[ "${model,,}" = "fx700" ]]; then
        target_addr=$(echo $server_info|awk '{print $7}')
        node_opts+=" \
            --driver fx-ipmi \
            --driver-info ipmi_priv_level=USER \
            --driver-info ipmi_bridging=single \
            --driver-info ipmi_target_channel=0 \
            --driver-info ipmi_target_address=$target_addr"
	    ((i+=1))
    else
        node_opts+=" \
            --driver ipmi"

    fi

    boot_option=$(echo $server_info|awk -v i=$i '{print $(7+i)}')
    root_disk_hint=$(echo $server_info|awk -v i=$i '{print $(8+i)}')
    root_disk_hint_value=$(echo $server_info|awk -v i=$i '{print $(9+i)}')

    if [[ "$name" == "auto" ]]; then
        node_name=${model,,}-$(printf "%02d" $server_count)
    else
        node_name=$name
    fi
    cpus=$(get_cpus $model)

    # if flavor not existed, 
    # then create it
    flavor_name_prefix=bm.${model,,}
    flavor=$(openstack flavor list|grep -i $flavor_name_prefix) || true
    if [[ -z $flavor ]]; then
        resource_class=CUSTOM_${RESOURCE_CLASS^^}_${model^^}
	volume_boot_flavor_name=${flavor_name_prefix}.volume-boot
	local_boot_flavor_name=${flavor_name_prefix}.local-boot
        openstack flavor create --ram 1 --vcpus 1 \
            --disk $DISK_GB  $volume_boot_flavor_name
        openstack flavor set $volume_boot_flavor_name \
            --property resources:$resource_class=1 \
            --property resources:VCPU=0 \
            --property resources:MEMORY_MB=0 \
            --property resources:DISK_GB=0 \
            --property capabilities:boot_option='netboot'
        openstack flavor create --ram 1 --vcpus 1 \
            --disk $DISK_GB  $local_boot_flavor_name
        openstack flavor set $local_boot_flavor_name \
            --property resources:$resource_class=1 \
            --property resources:VCPU=0 \
            --property resources:MEMORY_MB=0 \
            --property resources:DISK_GB=0 \
            --property capabilities:boot_option='local'
    fi

    deploy_kernel_id=$(openstack image show bm-deploy-kernel \
                        -f value -c id)
    deploy_initrd_id=$(openstack image show bm-deploy-initrd \
                        -f value -c id)
    resource_class=${RESOURCE_CLASS,,}-${model,,}

    cap_prop="boot_mode:uefi,boot_option:$boot_option"

    # Note: Set capabilities=boot_option:local if it has disk for local disk boot
    # and only one boot_option could be set once time.
    node_id=$(openstack baremetal node create \
        --name $node_name \
        --driver-info ipmi_username=$bmc_user \
        --driver-info ipmi_password=$bmc_passwd \
        --driver-info ipmi_address=$bmc_ip \
        --driver-info deploy_kernel=$deploy_kernel_id \
        --driver-info deploy_ramdisk=$deploy_initrd_id \
        --resource-class $resource_class \
        --property cpu_arch=aarch64 \
        --property cpus=$cpus \
        --property memory_mb=$RAM_MB \
        --property capabilities=$cap_prop \
        --deploy-interface iscsi \
        -f value -c uuid $node_opts)
    
    openstack baremetal port create $mac_addr --node $node_id --physical-network physnet1

    node_extra_opts=""
    if [[ "$boot_option" == "netboot" ]];then
	    cap_prop+=",iscsi_boot:True"
        node_extra_opts+=" \
            --network-interface flat \
            --storage-interface cinder \
            --property capabilities=$cap_prop"
        # create initiator
        connector_iqn="iqn.2017-05.org.openstack:node-$node_name"
        openstack baremetal volume connector create \
            --node $node_id --type iqn \
            --connector-id $connector_iqn
    elif [[ "$boot_option" == "local" ]];then
        node_extra_opts+=" \
            --network-interface neutron"
        if [[ -n $root_disk_hint ]]; then
            node_extra_opts+=" --property root_device={\"$root_disk_hint\":\"$root_disk_hint_value\"}"
        fi
        # TODO: Add port local-link-connection
        echo "Please add local-link-connection for node $node_name manually!!"
    else
        echo "Wrong boot_option: $boot_option!! Deleting node $node_name. "
        openstack baremetal node delete  $node_id
    fi

    openstack baremetal node set $node_id $node_extra_opts
    openstack baremetal node manage $node_id
    openstack baremetal node provide $node_id

    echo "Server count: $server_count"
    server_count=$((server_count+1))
done < $server_info_file
openstack baremetal node list
echo "Enroll server finish."
