FROM freeradius-3-testing-shared

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends supervisor python3-pip freeradius-rest freeradius-config  && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

RUN pip3 install watchdog==2.1.9

COPY config_watch.py /usr/local/bin
RUN chmod 755 /usr/local/bin/config_watch.py

COPY supervisord.conf /etc

COPY build-config/ /etc/freeradius/3.0/

ENV certdir=/etc/freeradius/3.0/certs

RUN echo '\nexec env HOST_IP=$HOST_IP gosu runuser supervisord' >> /usr/local/bin/start.sh
