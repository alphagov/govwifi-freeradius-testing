build:
	docker build -t freeradius-3-testing-shared freeradius-3-testing-shared/
	docker build -t freeradius-3-testing-server freeradius-3-testing-server/
	docker build -t freeradius-3-testing-tools freeradius-3-testing-tools/

reset-config:
	rm -rf freeradius-config
	docker run --rm -it -v=$(CURDIR):/host -e USERID=$(shell id -u) -e GROUPID=$(shell id -g) freeradius-3-testing-server sh -c 'cp -r /etc/freeradius/3.0 /host/freeradius-config && chown -R $$USERID:$$GROUPID /host/freeradius-config'

server-start:
	docker run --rm -t -v=$(CURDIR)/freeradius-config:/etc/freeradius/3.0 -p 1812-1813:1812-1813/udp -e USERID=$(shell id -u) -e GROUPID=$(shell id -g) --name=freeradius-3-testing-server-c freeradius-3-testing-server

tools-start:
	docker run --rm -i -t -e USERID=$(shell id -u) -e GROUPID=$(shell id -g) --name=freeradius-3-testing-tools-c freeradius-3-testing-tools
 