FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends gosu nano wget curl openssh-client rsync ca-certificates zip unzip && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends wpasupplicant freeradius freeradius-rest freeradius-utils freeradius-config openssl make && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY start.sh /usr/local/bin
RUN chmod 744 /usr/local/bin/start.sh

COPY freeradius-init/ /etc/freeradius/3.0

RUN groupadd --gid 1000 runuser && \
    useradd --home-dir /home/runuser --shell /bin/bash --uid 1000 --gid 1000 runuser && \
    mkdir -p /data
VOLUME /home/runuser

CMD ["/usr/local/bin/start.sh"]