build:
	docker build -t freeradius-3-ubuntu .

reset-config:
	rm -rf freeradius-config
	docker run --rm -it -v=$(CURDIR):/host -e USERID=$(shell id -u) -e GROUPID=$(shell id -g) freeradius-3-ubuntu sh -c 'cp -r /etc/freeradius/3.0 /host/freeradius-config && chown -R $$USERID:$$GROUPID /host/freeradius-config'

start:
	docker run --rm -t -v=$(CURDIR)/freeradius-config:/etc/freeradius/3.0 -p 1812-1813:1812-1813/udp -e USERID=$(shell id -u) -e GROUPID=$(shell id -g) --name=freeradius-3-ubuntu-c freeradius-3-ubuntu
 