FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends supervisor gosu nano wget curl openssh-client ca-certificates python3-pip && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends wpasupplicant freeradius freeradius-rest freeradius-utils freeradius-config openssl iproute2 && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY start.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/start.sh

RUN pip3 install watchdog==2.1.9

COPY config_watch.py /usr/local/bin
RUN chmod 755 /usr/local/bin/config_watch.py

COPY supervisord.conf /etc

COPY build-config/ /etc/freeradius/3.0/

RUN mkdir /home/runuser && \
    groupadd --gid 1000 runuser && \
    useradd --home-dir /home/runuser --shell /bin/bash --uid 1000 --gid 1000 runuser && \
    chown -R runuser:runuser /home/runuser

ENV certdir=/etc/freeradius/3.0/certs

CMD ["/usr/local/bin/start.sh"]