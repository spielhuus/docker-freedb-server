#!/bin/bash

set -e
trap "exit" INT

# Ensure output directory exists
output=/usr/local/cddb
mkdir -p $output

# Target source file.
#url=$1
#if [[ -z $url ]]; then
  freedb=`curl -s http://ftp.freedb.org/pub/freedb/ | grep -o -E "freedb-complete-[[:digit:]]{8}" | tail -1`
  yyyymmdd=${freedb:16:8}
  url=http://ftp.freedb.org/pub/freedb/freedb-complete-$yyyymmdd.tar.bz2
#fi
file=${url##*/}

# Download latest FreeDB dump.
axel -a -o /tmp/$file -n 32 $url

# Unpack latest FreeDB records.
tar -C $output -xjf /tmp/$file
/usr/local/bin/cddbd -fd
rm /tmp/$file

#start the server
echo "start the server."
exec uwsgi /usr/local/cddbd/cddbd.ini 
#exec uwsgi /usr/local/cddbd/cddbd.ini > /dev/null 2>&1

