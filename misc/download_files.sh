#!/bin/bash

usage() {
	echo "Usage: $0 <url>"
	exit 0
}

if [ $# -lt 1 ]; then
	usage
fi

URL=${1%/}
ROOT_DIR=${URL##*/}
MD5SUMS_FILE="MD5SUMS.txt"

mkdir -p $ROOT_DIR && cd $ROOT_DIR
wget -c $URL/$MD5SUMS_FILE

if [ ! -e $MD5SUMS_FILE ]; then
	echo -e "\e[31mDownload $MD5SUMS_FILE failed!\e[0m"
	exit 1
fi

declare -A file_list
file_list=$(cat $MD5SUMS_FILE | awk '{print $2}')

for file in $file_list; do
	file_dir=$(dirname $file)
	mkdir -p $file_dir
	RET=$(echo $file|grep -E "*.iso")
	if [ -n "$RET" ]; then
		echo "Skip file: $file"
		continue; 
	fi
	wget -c $URL/$file -O $file
done

echo -e "\e[32mDownloaded files:\e[0m\n$file_list"
tree $PWD

echo -e "\e[32mMD5SUM check:\e[0m"
md5sum -c $MD5SUMS_FILE
