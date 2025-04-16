#!/bin/bash

##
## Count total sum of range, input file formart is shown as bellow:
##
#   0: 0x0000000000000000..0x000000002edfffff
#   1: 0x000000002ee00000..0x000000002fbfffff
#   2: 0x000000002fc00000..0x000000003073ffff
#   3: 0x0000000030740000..0x000000003074ffff
#   4: 0x0000000030750000..0x000000003076ffff
#   5: 0x0000000030770000..0x000000003077ffff
#   6: 0x0000000030780000..0x000000003958ffff
#   7: 0x0000000039590000..0x000000003982ffff
#   8: 0x0000000039830000..0x000000003987ffff
#   9: 0x0000000039880000..0x000000003991ffff


inputFile=$1
sum=0
lineNum=0

#echo $inputFile

while IFS= read -r line; do
	line=$(echo $line|awk '{print $2}')
	#echo $line
	a=$(echo $line|awk -F '.' '{print $1}')
	b=$(echo $line|awk -F '.' '{print $3}')
	sum=$(( b - a + sum))
	#echo "a=$a b=$b sum=$sum"
	(( lineNum++ ))
done < $inputFile

sum=$(( sum / 1024))
echo "TotalLine: $lineNum, sum: ${sum}K"
