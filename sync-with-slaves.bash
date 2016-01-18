#!/bin/bash

CURRDIR=$(readlink -e `dirname $0`)

for h in `cat etc/hadoop/slaves | grep -v localhost | grep -v 127.0.0.1`
do
  echo "Syncing current folder with slave $h ..."
  rsync -LavzPr --delete $CURRDIR $h:`dirname $CURRDIR`
done
