
chmod +x docker-entrypoint.sh


docker build -t freeradius-3-ubuntu .


docker run --rm -it -v=$(pwd):/host --entrypoint bash freeradius-3-ubuntu

...this instead...

docker run --rm -it -v=$(pwd):/host  freeradius-3-ubuntu cp -r /etc/freeradius /host/freeradius


sudo chown -R $UID:$GID freeradius


docker run --rm -t -p 1812-1813:1812-1813/udp freeradius-3-ubuntu
