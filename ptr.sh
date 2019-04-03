#!/bin/bash

ptr=`cat $1 | awk -F "'" '{print $2}' | sed -e 's/\/.*//' | sort | uniq `

for i in $ptr

do 

cat /opt/named/external/etc/named.conf |grep $i

done

