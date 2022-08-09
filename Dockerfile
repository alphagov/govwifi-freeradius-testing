FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends supervisor gosu nano wget curl openssh-client rsync ca-certificates zip unzip && \
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
RUN chmod 744 /usr/local/bin/start.sh

COPY freeradius-build-config/clients.conf /etc/freeradius/3.0

RUN mkdir /home/runuser && \
    groupadd --gid 1000 runuser && \
    useradd --home-dir /home/runuser --shell /bin/bash --uid 1000 --gid 1000 runuser && \
    chown -R runuser:runuser /home/runuser

ENV CERTDIR=/etc/freeradius/3.0/certs

RUN sed -i '1s/^/testing\tCleartext-Password := "password"\n/' /etc/freeradius/3.0/mods-config/files/authorize

RUN echo \
'[supervisord]\n\
nodaemon=true\n\
pidfile=/tmp/supervisord.pid\n\
logfile=/dev/fd/1\n\
logfile_maxbytes=0\n\n\
[program:freeradius]\n\
priority=1\n\
command=/usr/sbin/freeradius -X\n\
autorestart=true\n\
stdout_logfile=/dev/fd/1\n\
stdout_logfile_maxbytes=0\n\
redirect_stderr=true\n' \
> /etc/supervisord.conf

CMD ["/usr/local/bin/start.sh"]