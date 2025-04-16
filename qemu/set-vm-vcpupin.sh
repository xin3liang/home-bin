#!/bin/bash

vm=$1
cpuset=$2

[[ -z $vm ]] && vm=vm1
[[ -z $cpuset ]] && cpuset=0-23

VIRSH=$(command -v virsh) && $VIRSH --version
#VIRSH="echo $VIRSH"
cpu_start=${cpuset%%-*}
cpu_end=${cpuset##*-}

vcpu=0
for cpu in $(seq $cpu_start $cpu_end); do
        echo "$vm: Pin vcpu $vcpu to physical cpu $cpu"
        $VIRSH vcpupin $vm $vcpu $cpu --config --live
        ((vcpu++))
done
