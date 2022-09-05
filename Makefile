build:
	docker build -t freeradius-3-testing freeradius-3-testing/

copy-configs:
	rm -rf mounts/*
	touch mounts/.keep
	docker run --rm -it -v=$(CURDIR):/host -e USERID=$(shell id -u) -e GROUPID=$(shell id -g) freeradius-3-testing sh -c 'cp -r /etc/freeradius/3.0 /host/mounts/freeradius-config && chown -R $$USERID:$$GROUPID /host/mounts/freeradius-config'
	docker run --rm -it -v=$(CURDIR):/host -e USERID=$(shell id -u) -e GROUPID=$(shell id -g) freeradius-3-testing sh -c 'cp -r /etc/freeradius/3.0/eapol-test /host/mounts/eapol-test-configs && chown -R $$USERID:$$GROUPID /host/mounts/eapol-test-configs'

start:
	docker run --rm -t -v=f3t-runuser-homedir:/home/runuser -v=$(CURDIR)/mounts/freeradius-config:/etc/freeradius/3.0 -v=$(CURDIR)/mounts/eapol-test-configs:/etc/freeradius/eapol-test -p 1812-1813:1812-1813/udp -e USERID=$(shell id -u) -e GROUPID=$(shell id -g) --name=freeradius-3-testing-c freeradius-3-testing

shell:
	docker exec -it -u runuser freeradius-3-testing-c /bin/bash
 