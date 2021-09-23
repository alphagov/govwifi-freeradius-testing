#!/bin/bash

rm -rf freeradius-config && docker build -t freeradius-3-ubuntu .
docker run --rm -it -v=$(pwd):/host  freeradius-3-ubuntu cp -r /etc/freeradius/3.0 /host/freeradius-config && sudo chown -R $UID:$GID freeradius-config
docker run --rm -t -v=$(pwd)/freeradius-config:/etc/freeradius/3.0 -p 1812-1813:1812-1813/udp -e USERID=$UID -e GROUPID=$GID freeradius-3-ubuntu
