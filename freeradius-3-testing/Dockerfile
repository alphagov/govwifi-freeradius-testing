FROM ubuntu:20.04

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gosu nano curl ca-certificates \
    freeradius freeradius-rest freeradius-config freeradius-utils openssl iproute2 \
    supervisor python3-pip git build-essential libssl-dev devscripts pkg-config libnl-3-dev libnl-genl-3-dev && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir /home/runuser && \
    groupadd --gid 1000 runuser && \
    useradd --home-dir /home/runuser --shell /bin/bash --uid 1000 --gid 1000 runuser
    
COPY .bashrc /home/runuser
RUN  chown -R runuser:runuser /home/runuser
VOLUME /home/runuser

RUN git clone --depth 1 --single-branch --branch v3.2.x https://github.com/FreeRADIUS/freeradius-server.git && \
    /freeradius-server/scripts/ci/eapol_test-build.sh && \
    cp /freeradius-server/scripts/ci/eapol_test/eapol_test /usr/local/bin/ && \
    rm -rf /freeradius-server

COPY build-configs/freeradius-certs /etc/freeradius/3.0/certs
RUN chmod +x /etc/freeradius/3.0/certs/bootstrap && \
    /etc/freeradius/3.0/certs/bootstrap

COPY config_watch.py /usr/local/bin
RUN chmod 755 /usr/local/bin/config_watch.py
RUN pip3 install watchdog==2.1.9

COPY supervisord.conf /etc

COPY start.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/start.sh

COPY log_listener.py /usr/local/bin
RUN chmod 755 /usr/local/bin/log_listener.py

COPY build-configs/eapol-test /etc/freeradius/3.0/eapol-test

COPY build-configs/freeradius-default-min-changes /etc/freeradius/3.0/

ENV certdir=/etc/freeradius/3.0/certs

CMD ["/usr/local/bin/start.sh"]