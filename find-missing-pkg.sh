#!/bin/bash -x

input_file=$1
output_file="missing-pkgs.txt"

rm -rf $output_file 
while read line; do
    pkg=$(echo $line | awk '{print $1}')
    ret=$(dnf search $pkg)
    if [[ -z $ret ]]; then
        echo $pkg >> $output_file
    fi
done < $input_file
echo "lastine: $pkg"
