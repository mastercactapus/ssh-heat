#!/bin/bash
SUBNET="10\.42\."

for f in `ls -r /var/log/auth.log*`
do
  if [[ $f == *.gz ]]
  then
    zcat $f
  else
    cat $f
  fi
done | grep sshd | grep '\(Accept\|Fail\)' | grep -v 'from $SUBNET' | awk '{print "ATTEMPT SSH", $1, $2, $3, $6, $(NF - 3)}' | while read line
do
  ip=`echo "$line" | awk '{print $NF}'`
  coords=`geoiplookup $ip |grep "Rev 1" | awk -F", " '{print $(NF - 3), $(NF - 2)}'`
  echo "$line $coords"
done

