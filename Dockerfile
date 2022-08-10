FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends supervisor gosu nano wget curl openssh-client rsync ca-certificates python3-pip zip unzip && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends wpasupplicant freeradius freeradius-rest freeradius-utils freeradius-config openssl make && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY start.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/start.sh

COPY supervisord.conf /etc

COPY config_watch.py /usr/local/bin
RUN chmod 755 /usr/local/bin/config_watch.py

RUN pip3 install watchdog==2.1.9

RUN mkdir /home/runuser && \
    groupadd --gid 1000 runuser && \
    useradd --home-dir /home/runuser --shell /bin/bash --uid 1000 --gid 1000 runuser && \
    chown -R runuser:runuser /home/runuser

ENV CERTDIR=/etc/freeradius/3.0/certs

RUN sed -i '1s/^/testing\tCleartext-Password := "password"\n/' /etc/freeradius/3.0/mods-config/files/authorize

RUN sed -i '1s/^/client any_client {\n\tipaddr = 0.0.0.0\/0\n\tsecret = testing123\n}\n/' /etc/freeradius/3.0/clients.conf

CMD ["/usr/local/bin/start.sh"]