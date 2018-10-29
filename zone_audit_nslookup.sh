#!/bin/bash
#
#Marcus Patman 2/28/13
#
#This script parses the named.conf and extracts domain names.
#Followed by a nslookup on each one which outputs to the Results.txt
#filename provided.

if [ $# -eq 0 ] ; then
        echo "Usage: dns_audit.sh Server IP + named.conf + Results.txt"
        exit 0
fi

SERVER=$1
FILE=$2
RESULTS=$3
PROBLIST=$RESULTS.prob_hosts

if [ -e $RESULTS ]

then
        echo "File exists! Making backup!"
        cp $RESULTS $RESULTS.old
else
        echo "Touching results file"
        touch $RESULTS
fi

sleep 2

echo "Processing $FILE!"

sleep 2

ZONES=`cat $FILE | awk -F '"' '{print $2}' | sed '/master/d' | sed '/^$/d'`

for i in $ZONES

do

nslookup $i $SERVER | tee -a $RESULTS

done

clear

echo "Processing of $FILE complete.."

echo "Results can be viewed at $PWD/$RESULTS"

sleep 2

echo "Generating problem hosts list"

if [ -e $PROBLIST ]

then
        echo "File exists! Making backup!"
        cp $PROBLIST $PROBLIST.old
else
        echo "Touching prob results file"
        touch $PROBLIST
fi



cat $PWD/$RESULTS | awk '/No answer/{print}' | awk -F " " '{print $4}' | sed 's/:/ /' | sort | uniq > $PROBLIST
cat $PWD/$RESULTS | awk '/NXDOMAIN/{print}' | awk -F " " '{print $4}' | sed 's/:/ /' | sort | uniq >> $PROBLIST


echo "Problems were found with these zones:\n\n"

cat $PROBLIST


exit 0

