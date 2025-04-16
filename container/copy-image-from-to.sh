#!/bin/bash -ex
from_image=$1
to_image=$2

[[ -z "$to_image" ]] && to_image=quay.io/xin3liang0/${from_image##*/}

crane copy $from_image $to_image 
#crane index filter $from_image -t $to_image \
#    --platform linux/amd64 --platform linux/arm64 
